# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

versacommerce-cli is a Ruby gem providing a Command Line Interface tool for interacting with VersaCommerce Theme API services. The primary executable is `vc-theme`, which provides theme management capabilities (download, watch, upload).

**Ruby Version:** Requires Ruby >= 3.1.0 (upgraded from Ruby >= 2.0.0 in version 0.3.0)

## Development Commands

### Setup
```sh
bin/setup
```
Runs `bundle install` and any additional automated setup.

### Interactive Console
```sh
bin/console
```
Opens an interactive prompt for experimentation.

### Build & Release
```sh
rake build     # Build the gem
rake install   # Install gem locally
rake release   # Create git tag and push gem to RubyGems
```

### Testing the CLI Locally
```sh
bundle exec exe/vc-theme <command>
```
Run the CLI directly from source without installing the gem.

### Running Tests
```sh
ruby test/smoke_test.rb
```
Runs basic smoke tests to verify CLI functionality.

## Code Architecture

### Entry Point
- `exe/vc-theme` - Executable entry point that loads and starts `Versacommerce::CLI::Theme`

### Core Structure
The gem follows a simple modular architecture:

- `lib/versacommerce/cli.rb` - Root module definition
- `lib/versacommerce/cli/version.rb` - Version constant (update this when releasing)
- `lib/versacommerce/cli/theme.rb` - Main Thor-based CLI class with all command logic
- `lib/versacommerce/cli/simple_logger.rb` - Colorized logging utility

### Theme Commands Architecture (lib/versacommerce/cli/theme.rb)

The `Theme` class inherits from Thor and implements three main commands:

1. **download** - Downloads complete theme from Theme API to local directory
2. **watch** - Uses Listen gem to monitor file changes and sync to Theme API in real-time
3. **upload** - Recursively uploads directory tree to Theme API (delete then add for each file)

#### Authorization Resolution Chain
The CLI checks for authorization in this priority order:
1. `--authorization` command line option
2. `--config` explicit config file path
3. `config.yml` in current working directory
4. `THEME_AUTHORIZATION` environment variable
5. `~/.config/versacommerce/cli/config.yml` (implicit global config)

This is implemented in the `authorization` method on lib/versacommerce/cli/theme.rb:156.

#### File Operations Pattern
All commands follow a pattern:
1. Ensure authorization exists (`ensure_authorization!`)
2. Save config if `--save-config` flag present
3. Validate path is a directory
4. Perform operation using `versacommerce-theme_api_client` gem

The watch command uses `Listen.to()` with a block that handles modified/added/removed file arrays.

### Dependencies
- **thor** (~> 1.3) - CLI framework for building command-line interfaces (upgraded from 0.19.1)
- **listen** (~> 3.9) - File system change monitoring for watch command (upgraded from ~> 2.10)
- **colorize** (~> 1.1) - Terminal color output for logger (upgraded from 0.7.5)
- **versacommerce-theme_api_client** (~> 0.1.3) - API client for VersaCommerce Theme API

**Note:** For local development, the Gemfile references the local versacommerce-theme_api_client gem to use the Ruby 3.1+ compatible version.

## Version Bumping
Update `lib/versacommerce/cli/version.rb` with new version number before releasing.

**Current version:** 0.3.0 (Ruby 3.1+ support, dependency updates, security fixes)

## Recent Changes (v0.3.0)

### Ruby 3.1+ Upgrade
- Updated Ruby requirement from >= 2.0.0 to >= 3.1.0
- Fixed YAML.load_file security vulnerabilities (3 instances in theme.rb)
  - Now uses `YAML.load_file(path, permitted_classes: [Symbol])` for safe loading
- Modernized string interpolation from % formatting to #{} syntax
- Fixed Thor 1.x compatibility issues:
  - Changed Pathname default values to strings
  - Added `exit_on_failure?` method
- Updated all dependencies to Ruby 3.1+ compatible versions

### Testing
- Added basic smoke tests in `test/smoke_test.rb`
- Tests verify CLI loading, help commands, and YAML config loading
