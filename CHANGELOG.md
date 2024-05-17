# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-04-03

### Added
- `lap_stats` for aggregate lap statistics (count, total, avg, min, max)
- `formatted_elapsed` for human-readable time display
- `formatted_laps` for formatted lap summaries
- `measure_formatted` class method for quick formatted measurements

## [0.1.6] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.5] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.4] - 2026-03-26

### Changed

- Add Sponsor badge and fix License link format in README

## [0.1.3] - 2026-03-24

### Fixed

- Standardize README code examples to use double-quote require statements
- Remove inline comments from Development section to match template

## [0.1.2] - 2026-03-24

### Fixed

- Fix Installation section quote style to double quotes

## [0.1.1] - 2026-03-22

### Changed

- Expand test coverage to 30+ examples with start/stop/reset lifecycle, lap accumulation, elapsed monotonicity, multiple independent timers, method chaining, and pause edge cases

## [0.1.0] - 2026-03-22

### Added

- Initial release
- Start, stop, and reset controls
- Lap timing with optional names
- Pause and resume support
- High-resolution monotonic clock
- Class-level measure helper for block timing
