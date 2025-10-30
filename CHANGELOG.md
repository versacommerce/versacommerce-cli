# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-10-30

### Changed
- Updated dependency to `versacommerce-theme_api_client` ~> 1.0.3
- Fixes SSL verification functionality with HTTP gem 5.x

## [1.0.2] - 2025-10-30

### Added
- `--ssl-verify` / `--no-ssl-verify` option to control SSL certificate verification
- `--base-url` / `-b` option to specify custom Theme API endpoint
- Support for `SSL_VERIFY` environment variable
- Support for `THEME_API_BASE_URL` environment variable
- Configuration file support for `ssl_verify` and `base_url` settings
- Comprehensive help descriptions for all CLI options
- Documentation for new options in README

### Changed
- All class options now include descriptive help text
- Client initialization updated to pass `ssl_verify` and `base_url` parameters

## [1.0.1] - Previous Release

### Changed
- Updated to Ruby 3.1+
- Updated dependencies
