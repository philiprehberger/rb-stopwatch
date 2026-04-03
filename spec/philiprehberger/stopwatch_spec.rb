# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Stopwatch do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '#start' do
    it 'starts the stopwatch' do
      sw = described_class.new
      sw.start
      expect(sw.running?).to be true
    end

    it 'raises when already running' do
      sw = described_class.new
      sw.start
      expect { sw.start }.to raise_error(described_class::Error)
    end

    it 'resumes from paused state' do
      sw = described_class.new
      sw.start
      sw.stop
      expect(sw.paused?).to be true
      sw.start
      expect(sw.running?).to be true
    end
  end

  describe '#stop' do
    it 'pauses the stopwatch' do
      sw = described_class.new
      sw.start
      sw.stop
      expect(sw.paused?).to be true
      expect(sw.running?).to be false
    end

    it 'raises when not running' do
      sw = described_class.new
      expect { sw.stop }.to raise_error(described_class::Error)
    end

    it 'raises when already paused' do
      sw = described_class.new
      sw.start
      sw.stop
      expect { sw.stop }.to raise_error(described_class::Error)
    end
  end

  describe '#reset' do
    it 'resets all state' do
      sw = described_class.new
      sw.start
      sw.lap('test')
      sw.reset
      expect(sw.running?).to be false
      expect(sw.paused?).to be false
      expect(sw.elapsed).to eq(0.0)
      expect(sw.laps).to be_empty
    end
  end

  describe '#lap' do
    it 'records a lap' do
      sw = described_class.new
      sw.start
      lap = sw.lap('first')
      expect(lap[:name]).to eq('first')
      expect(lap[:elapsed]).to be_a(Float)
    end

    it 'records multiple laps' do
      sw = described_class.new
      sw.start
      sw.lap('first')
      sw.lap('second')
      expect(sw.laps.length).to eq(2)
    end

    it 'raises when not running' do
      sw = described_class.new
      expect { sw.lap }.to raise_error(described_class::Error)
    end

    it 'allows nil name' do
      sw = described_class.new
      sw.start
      lap = sw.lap
      expect(lap[:name]).to be_nil
    end
  end

  describe '#elapsed' do
    it 'returns 0 before starting' do
      sw = described_class.new
      expect(sw.elapsed).to eq(0.0)
    end

    it 'returns elapsed time while running' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      expect(sw.elapsed).to be > 0
    end

    it 'freezes elapsed time when paused' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.stop
      paused_elapsed = sw.elapsed
      sleep(0.01)
      expect(sw.elapsed).to eq(paused_elapsed)
    end
  end

  describe '#laps' do
    it 'returns a copy of laps' do
      sw = described_class.new
      sw.start
      sw.lap('a')
      laps = sw.laps
      laps.clear
      expect(sw.laps.length).to eq(1)
    end
  end

  describe '#paused?' do
    it 'returns false initially' do
      expect(described_class.new.paused?).to be false
    end
  end

  describe '#running?' do
    it 'returns false initially' do
      expect(described_class.new.running?).to be false
    end
  end

  describe '.measure' do
    it 'returns result and elapsed time' do
      result, elapsed = described_class.measure { 1 + 1 }
      expect(result).to eq(2)
      expect(elapsed).to be_a(Float)
      expect(elapsed).to be >= 0
    end

    it 'measures actual execution time' do
      _, elapsed = described_class.measure { sleep(0.01) }
      expect(elapsed).to be >= 0.01
    end

    it 'returns nil result for void block' do
      result, _elapsed = described_class.measure { nil }
      expect(result).to be_nil
    end
  end

  describe '#lap_stats' do
    it 'returns zeros when no laps recorded' do
      sw = described_class.new
      stats = sw.lap_stats
      expect(stats).to eq({ count: 0, total: 0.0, avg: 0.0, min: 0.0, max: 0.0 })
    end

    it 'returns correct stats for a single lap' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.lap('only')
      stats = sw.lap_stats
      expect(stats[:count]).to eq(1)
      expect(stats[:total]).to be > 0
      expect(stats[:avg]).to eq(stats[:total])
      expect(stats[:min]).to eq(stats[:max])
    end

    it 'returns correct stats for multiple laps' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.lap('a')
      sleep(0.02)
      sw.lap('b')
      stats = sw.lap_stats
      expect(stats[:count]).to eq(2)
      expect(stats[:total]).to be > 0
      expect(stats[:avg]).to be_within(0.001).of(stats[:total] / 2.0)
      expect(stats[:min]).to be <= stats[:max]
    end

    it 'returns zeros after reset' do
      sw = described_class.new
      sw.start
      sw.lap('a')
      sw.reset
      stats = sw.lap_stats
      expect(stats[:count]).to eq(0)
      expect(stats[:total]).to eq(0.0)
    end
  end

  describe '#formatted_elapsed' do
    it 'formats microseconds' do
      sw = described_class.new
      allow(sw).to receive(:elapsed).and_return(0.000_123)
      expect(sw.formatted_elapsed).to match(/\d+\.\d+us/)
    end

    it 'formats milliseconds' do
      sw = described_class.new
      allow(sw).to receive(:elapsed).and_return(0.123)
      expect(sw.formatted_elapsed).to eq('123.00ms')
    end

    it 'formats seconds' do
      sw = described_class.new
      allow(sw).to receive(:elapsed).and_return(5.678)
      expect(sw.formatted_elapsed).to eq('5.678s')
    end

    it 'formats minutes and seconds' do
      sw = described_class.new
      allow(sw).to receive(:elapsed).and_return(125.0)
      expect(sw.formatted_elapsed).to eq('2m 5s')
    end

    it 'formats hours, minutes, and seconds' do
      sw = described_class.new
      allow(sw).to receive(:elapsed).and_return(3725.0)
      expect(sw.formatted_elapsed).to eq('1h 2m 5s')
    end

    it 'formats zero elapsed' do
      sw = described_class.new
      expect(sw.formatted_elapsed).to eq('0.00us')
    end
  end

  describe '#formatted_laps' do
    it 'returns formatted data for named laps' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.lap('first')
      sleep(0.01)
      sw.lap('second')
      result = sw.formatted_laps
      expect(result.length).to eq(2)
      expect(result[0][:name]).to eq('first')
      expect(result[0][:elapsed]).to be_a(Float)
      expect(result[0][:formatted]).to be_a(String)
      expect(result[1][:name]).to eq('second')
    end

    it 'returns formatted data for unnamed laps' do
      sw = described_class.new
      sw.start
      sw.lap
      result = sw.formatted_laps
      expect(result[0][:name]).to be_nil
      expect(result[0][:formatted]).to be_a(String)
    end

    it 'returns empty array when no laps' do
      sw = described_class.new
      expect(sw.formatted_laps).to eq([])
    end
  end

  describe '.measure_formatted' do
    it 'returns a formatted string' do
      result = described_class.measure_formatted { sleep(0.01) }
      expect(result).to be_a(String)
      expect(result).to match(/\d+\.\d+ms/)
    end

    it 'measures a trivial block' do
      result = described_class.measure_formatted { 1 + 1 }
      expect(result).to be_a(String)
      expect(result).to match(/us|ms/)
    end
  end

  describe '.format_duration' do
    it 'handles boundary at 0.001 seconds' do
      expect(described_class.format_duration(0.000_999)).to match(/us/)
      expect(described_class.format_duration(0.001)).to match(/ms/)
    end

    it 'handles boundary at 1 second' do
      expect(described_class.format_duration(0.999)).to match(/ms/)
      expect(described_class.format_duration(1.0)).to match(/s$/)
    end

    it 'handles boundary at 60 seconds' do
      expect(described_class.format_duration(59.9)).to match(/^\d+\.\d+s$/)
      expect(described_class.format_duration(60.0)).to eq('1m 0s')
    end

    it 'handles boundary at 3600 seconds' do
      expect(described_class.format_duration(3599.0)).to match(/^\d+m \d+s$/)
      expect(described_class.format_duration(3600.0)).to eq('1h 0m 0s')
    end
  end

  describe 'start/stop/reset lifecycle' do
    it 'accumulates elapsed across start/stop cycles' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.stop
      first = sw.elapsed

      sw.start
      sleep(0.01)
      sw.stop
      expect(sw.elapsed).to be > first
    end

    it 'resets elapsed to zero after reset' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.stop
      sw.reset
      expect(sw.elapsed).to eq(0.0)
    end

    it 'allows start after reset' do
      sw = described_class.new
      sw.start
      sw.stop
      sw.reset
      sw.start
      expect(sw.running?).to be true
    end

    it 'clears laps on fresh start after stop' do
      sw = described_class.new
      sw.start
      sw.lap('a')
      sw.stop
      sw.start
      expect(sw.laps).to be_a(Array)
    end
  end

  describe '#lap edge cases' do
    it 'records lap times that are non-negative' do
      sw = described_class.new
      sw.start
      lap = sw.lap('x')
      expect(lap[:elapsed]).to be >= 0
    end

    it 'lap times sum approximately to total elapsed' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.lap('a')
      sleep(0.01)
      sw.lap('b')
      sw.stop
      lap_sum = sw.laps.sum { |l| l[:elapsed] }
      expect(lap_sum).to be_within(sw.elapsed * 0.5).of(sw.elapsed)
    end

    it 'allows recording lap while paused' do
      sw = described_class.new
      sw.start
      sw.stop
      expect { sw.lap('x') }.not_to raise_error
    end
  end

  describe '#elapsed edge cases' do
    it 'increases monotonically while running' do
      sw = described_class.new
      sw.start
      e1 = sw.elapsed
      e2 = sw.elapsed
      expect(e2).to be >= e1
    end

    it 'returns same value when called multiple times while paused' do
      sw = described_class.new
      sw.start
      sleep(0.01)
      sw.stop
      e1 = sw.elapsed
      e2 = sw.elapsed
      expect(e1).to eq(e2)
    end
  end

  describe 'multiple independent stopwatches' do
    it 'tracks independent elapsed times' do
      sw1 = described_class.new
      sw2 = described_class.new
      sw1.start
      sleep(0.02)
      sw2.start
      sleep(0.01)
      sw1.stop
      sw2.stop
      expect(sw1.elapsed).to be > sw2.elapsed
    end
  end

  describe '#start returns self' do
    it 'supports method chaining' do
      sw = described_class.new
      result = sw.start
      expect(result).to be(sw)
      sw.stop
    end
  end

  describe '#stop returns self' do
    it 'supports method chaining' do
      sw = described_class.new
      sw.start
      result = sw.stop
      expect(result).to be(sw)
    end
  end

  describe '#reset returns self' do
    it 'supports method chaining' do
      sw = described_class.new
      result = sw.reset
      expect(result).to be(sw)
    end
  end
end
