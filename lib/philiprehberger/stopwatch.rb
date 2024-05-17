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

      @start_time = now
      if @paused
        @paused = false
      else
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

    # Get aggregate statistics across all recorded laps
    #
    # @return [Hash] { count:, total:, avg:, min:, max: }
    def lap_stats
      if @laps.empty?
        return { count: 0, total: 0.0, avg: 0.0, min: 0.0, max: 0.0 }
      end

      times = @laps.map { |l| l[:elapsed] }
      total = times.sum
      {
        count: times.length,
        total: total,
        avg: total / times.length,
        min: times.min,
        max: times.max
      }
    end

    # Format elapsed time as a human-readable string
    #
    # @return [String]
    def formatted_elapsed
      self.class.format_duration(elapsed)
    end

    # Get formatted lap data
    #
    # @return [Array<Hash>] each with :name, :elapsed, :formatted
    def formatted_laps
      @laps.map do |lap|
        {
          name: lap[:name],
          elapsed: lap[:elapsed],
          formatted: self.class.format_duration(lap[:elapsed])
        }
      end
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

    # Measure execution time and return formatted string
    #
    # @yield block to measure
    # @return [String] formatted elapsed time
    def self.measure_formatted(&)
      _, elapsed = measure(&)
      format_duration(elapsed)
    end

    # Format a duration in seconds as a human-readable string
    #
    # @param seconds [Float]
    # @return [String]
    def self.format_duration(seconds)
      if seconds < 0.001
        format('%.2fus', seconds * 1_000_000)
      elsif seconds < 1.0
        format('%.2fms', seconds * 1_000)
      elsif seconds < 60.0
        format('%.3fs', seconds)
      elsif seconds < 3600.0
        minutes = (seconds / 60).to_i
        secs = (seconds % 60).to_i
        "#{minutes}m #{secs}s"
      else
        hours = (seconds / 3600).to_i
        minutes = ((seconds % 3600) / 60).to_i
        secs = (seconds % 60).to_i
        "#{hours}h #{minutes}m #{secs}s"
      end
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
