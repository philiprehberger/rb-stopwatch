# philiprehberger-stopwatch

[![Tests](https://github.com/philiprehberger/rb-stopwatch/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-stopwatch/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-stopwatch.svg)](https://rubygems.org/gems/philiprehberger-stopwatch)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-stopwatch)](https://github.com/philiprehberger/rb-stopwatch/commits/main)

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
sw.laps     # => [{name: "phase 1", elapsed: 0.5, split: 0.5}, {name: "phase 2", elapsed: 0.734, split: 1.234}]
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

### Formatted Output

```ruby
sw = Philiprehberger::Stopwatch.new
sw.start
sleep(0.5)
sw.formatted_elapsed  # => "500.12ms"

sleep(65)
sw.formatted_elapsed  # => "1m 5s"
```

### Lap Statistics

```ruby
sw = Philiprehberger::Stopwatch.new
sw.start
sw.lap('setup')
sw.lap('process')
sw.lap('teardown')

sw.lap_stats
# => { count: 3, total: 0.053, avg: 0.018, min: 0.005, max: 0.031 }

sw.formatted_laps
# => [{ name: "setup", elapsed: 0.005, formatted: "5.00ms" }, ...]
```

### Serialization

```ruby
sw = Philiprehberger::Stopwatch.new
sw.start
sw.lap('setup')
sw.lap('process')
sw.stop

sw.to_h
# => { running: false, paused: true, elapsed: 0.053,
#      formatted_elapsed: "53.00ms", laps: [...], lap_stats: {...} }
```

### Block Timing

```ruby
result, elapsed = Philiprehberger::Stopwatch.measure { expensive_operation }
puts "Took #{elapsed} seconds"

formatted = Philiprehberger::Stopwatch.measure_formatted { expensive_operation }
puts "Took #{formatted}"  # => "Took 12.50ms"
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
| `#elapsed_ms` | Total elapsed time in milliseconds |
| `#elapsed_us` | Total elapsed time in microseconds |
| `#laps` | Array of recorded lap data |
| `#running?` | Whether the stopwatch is actively running |
| `#paused?` | Whether the stopwatch is paused |
| `#lap_stats` | Aggregate lap statistics (count, total, avg, min, max) |
| `#formatted_elapsed` | Human-readable elapsed time string |
| `#formatted_laps` | Array of laps with formatted times |
| `#to_h` | Serialize full stopwatch state to a hash |
| `Stopwatch.measure { block }` | Measure block execution time |
| `Stopwatch.measure_formatted { block }` | Measure block and return formatted string |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-stopwatch)

🐛 [Report issues](https://github.com/philiprehberger/rb-stopwatch/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-stopwatch/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
