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
  end
end
