# frozen_string_literal: true

require_relative 'stopwatch/version'

module Philiprehberger
  class Stopwatch
    class Error < StandardError; end

    def initialize
      @laps = []
      @running = false
      @paused = false
      @start_time = nil
      @elapsed_before_pause = 0.0
      @lap_start = nil
    end

    # Start the stopwatch
    #
    # @return [self]
    def start
      raise Error, 'stopwatch is already running' if @running && !@paused

      if @paused
        @start_time = now
        @paused = false
      else
        @start_time = now
        @elapsed_before_pause = 0.0
        @lap_start = @start_time
        @laps = []
      end
      @running = true
      self
    end

    # Stop (pause) the stopwatch
    #
    # @return [self]
    def stop
      raise Error, 'stopwatch is not running' unless @running
      raise Error, 'stopwatch is already paused' if @paused

      @elapsed_before_pause += now - @start_time
      @paused = true
      self
    end

    # Reset the stopwatch
    #
    # @return [self]
    def reset
      @laps = []
      @running = false
      @paused = false
      @start_time = nil
      @elapsed_before_pause = 0.0
      @lap_start = nil
      self
    end

    # Record a lap
    #
    # @param name [String, nil] optional lap name
    # @return [Hash] lap data with name and elapsed time
    def lap(name = nil)
      raise Error, 'stopwatch is not running' unless @running

      current = now
      lap_elapsed = current - @lap_start
      lap_data = { name: name, elapsed: lap_elapsed }
      @laps << lap_data
      @lap_start = current
      lap_data
    end

    # Get total elapsed time in seconds
    #
    # @return [Float]
    def elapsed
      if @running && !@paused
        @elapsed_before_pause + (now - @start_time)
      else
        @elapsed_before_pause
      end
    end

    # Get all recorded laps
    #
    # @return [Array<Hash>]
    def laps
      @laps.dup
    end

    # Check if the stopwatch is paused
    #
    # @return [Boolean]
    def paused?
      @paused
    end

    # Check if the stopwatch is running (and not paused)
    #
    # @return [Boolean]
    def running?
      @running && !@paused
    end

    # Measure execution time of a block
    #
    # @yield block to measure
    # @return [Array] [result, elapsed_seconds]
    def self.measure
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      result = yield
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time
      [result, elapsed]
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
