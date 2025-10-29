#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'open3'

# Basic smoke tests for versacommerce-cli
# These tests verify that the CLI loads and responds to basic commands

def test_cli_help
  puts "Testing: vc-theme --help"
  stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/vc-theme', '--help')

  if status.success? && stdout.include?('Commands:')
    puts "✓ CLI help command works"
    true
  else
    puts "✗ CLI help command failed"
    puts "STDERR: #{stderr}" unless stderr.empty?
    false
  end
end

def test_download_help
  puts "Testing: vc-theme download --help"
  stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/vc-theme', 'download', '--help')

  if status.success? && stdout.include?('download')
    puts "✓ Download help command works"
    true
  else
    puts "✗ Download help command failed"
    puts "STDERR: #{stderr}" unless stderr.empty?
    false
  end
end

def test_watch_help
  puts "Testing: vc-theme watch --help"
  stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/vc-theme', 'watch', '--help')

  if status.success? && stdout.include?('watch')
    puts "✓ Watch help command works"
    true
  else
    puts "✗ Watch help command failed"
    puts "STDERR: #{stderr}" unless stderr.empty?
    false
  end
end

def test_upload_help
  puts "Testing: vc-theme upload --help"
  stdout, stderr, status = Open3.capture3('bundle', 'exec', 'exe/vc-theme', 'upload', '--help')

  if status.success? && stdout.include?('upload')
    puts "✓ Upload help command works"
    true
  else
    puts "✗ Upload help command failed"
    puts "STDERR: #{stderr}" unless stderr.empty?
    false
  end
end

def test_yaml_config_loading
  puts "Testing: YAML config file loading"
  require 'tempfile'
  require 'versacommerce/cli/theme'

  # Create a test config file
  config_file = Tempfile.new(['config', '.yml'])
  config_file.write("authorization: test_auth_value\n")
  config_file.close

  # Test that YAML loads without warnings
  require 'yaml'
  config = YAML.load_file(config_file.path, permitted_classes: [Symbol])

  if config['authorization'] == 'test_auth_value'
    puts "✓ YAML config loading works"
    true
  else
    puts "✗ YAML config loading failed"
    false
  end
ensure
  config_file.unlink if config_file
end

# Run all tests
puts "Running smoke tests for versacommerce-cli v#{`grep VERSION lib/versacommerce/cli/version.rb | grep -oE "[0-9]+\\.[0-9]+\\.[0-9]+"`}"
puts "=" * 60

results = []
results << test_cli_help
results << test_download_help
results << test_watch_help
results << test_upload_help
results << test_yaml_config_loading

puts "=" * 60
puts "Results: #{results.count(true)}/#{results.size} tests passed"

exit results.all? ? 0 : 1
