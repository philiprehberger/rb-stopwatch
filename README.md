# philiprehberger-stopwatch

[![Tests](https://github.com/philiprehberger/rb-stopwatch/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-stopwatch/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-stopwatch.svg)](https://rubygems.org/gems/philiprehberger-stopwatch)
[![License](https://img.shields.io/github/license/philiprehberger/rb-stopwatch)](LICENSE)

Precision stopwatch with lap timing, pause/resume, and formatted output

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-stopwatch"
```

Or install directly:

```bash
gem install philiprehberger-stopwatch
```

## Usage

```ruby
require "philiprehberger/stopwatch"

sw = Philiprehberger::Stopwatch.new
sw.start
# ... do work ...
sw.lap('phase 1')
# ... do more work ...
sw.lap('phase 2')
sw.stop

sw.elapsed  # => 1.234 (seconds)
sw.laps     # => [{name: "phase 1", elapsed: 0.5}, {name: "phase 2", elapsed: 0.734}]
```

### Pause and Resume

```ruby
sw = Philiprehberger::Stopwatch.new
sw.start
sleep(0.1)
sw.stop       # pause
sw.start      # resume
sleep(0.1)
sw.stop
sw.elapsed    # => ~0.2 (paused time not counted)
```

### Block Timing

```ruby
result, elapsed = Philiprehberger::Stopwatch.measure { expensive_operation }
puts "Took #{elapsed} seconds"
```

## API

| Method | Description |
|--------|-------------|
| `Stopwatch.new` | Create a new stopwatch |
| `#start` | Start or resume the stopwatch |
| `#stop` | Pause the stopwatch |
| `#reset` | Reset all state |
| `#lap(name)` | Record a lap with optional name |
| `#elapsed` | Total elapsed time in seconds |
| `#laps` | Array of recorded lap data |
| `#running?` | Whether the stopwatch is actively running |
| `#paused?` | Whether the stopwatch is paused |
| `Stopwatch.measure { block }` | Measure block execution time |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
