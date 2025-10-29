# Ruby 2.6.9 to 3.3 Upgrade - Onboarding Document

## Task Overview
Upgrade the versacommerce-cli Ruby gem from Ruby 2.6.9 to Ruby 3.3, ensuring all dependencies are compatible and code follows Ruby 3.3 best practices.

## Current State Analysis

### Project Information
- **Gem Name**: versacommerce-cli
- **Current Version**: 0.2.3
- **Type**: Ruby CLI tool for VersaCommerce Theme API
- **Main Executable**: `vc-theme`
- **Current Ruby Requirement**: >= 2.0.0 (very permissive)
- **LOC**: ~220 lines of Ruby code across 4 files

### System Ruby Version
- Currently running: Ruby 3.1.3p185
- Target: Ruby 3.3.x

### Core Functionality
1. **download** - Downloads theme from API to local directory
2. **watch** - Monitors file changes and syncs to API in real-time
3. **upload** - Uploads directory tree to API

## Critical Issues Identified

### 🚨 SECURITY VULNERABILITY: YAML.load_file
**File**: `lib/versacommerce/cli/theme.rb`
**Lines**: 160, 166, 173

```ruby
# Current (INSECURE):
YAML.load_file(config)

# Required (SECURE):
YAML.load_file(config, permitted_classes: [Symbol])
```

**Why Critical**:
- Deprecated in Ruby 3.1+
- Arbitrary code execution vulnerability
- Will be removed in future Ruby versions

### 🔴 OUTDATED DEPENDENCIES (10 years old!)

#### Runtime Dependencies
| Gem | Current | Age | Target | Risk Level |
|-----|---------|-----|--------|------------|
| thor | 0.19.1 (exact) | 2015 | ~> 1.3 | HIGH |
| listen | ~> 2.10 | 2015 | ~> 3.9 | HIGH |
| colorize | 0.7.5 (exact) | 2015 | ~> 1.1 | LOW |
| versacommerce-theme_api_client | 0.1.3 (exact) | Unknown | TBD | **UNKNOWN** |

#### Development Dependencies
| Gem | Current | Target | Risk Level |
|-----|---------|--------|------------|
| bundler | ~> 1.8 | >= 1.8 | MEDIUM |
| rake | ~> 10.4 | ~> 13.0 | LOW |
| pry | 0.10.1 (exact) | ~> 0.14 | LOW |
| pry-stack_explorer | 0.4.9.2 (exact) | ~> 0.6 | LOW |

**Key Problem**: Exact version pins (0.19.1, 0.7.5) prevent security updates!

### ⚠️ POTENTIAL BLOCKER: versacommerce-theme_api_client

**Status**: UNKNOWN Ruby 3.3 compatibility
**Risk**: Could be complete blocker if incompatible
**Action Required**: Must investigate this dependency before proceeding

## Code Compatibility Analysis

### ✅ Already Compatible
- **Keyword arguments**: Correct Ruby 3.0+ syntax already in use
- **Hash syntax**: Modern syntax (`key: value`)
- **File operations**: Using Pathname and FileUtils properly
- **No deprecated Ruby 2.x patterns found**

### 🔧 Needs Fixing
1. **YAML.load_file** (3 instances) - Security + deprecation
2. **Gemspec dependency versions** (all outdated)
3. **Documentation** (README.md mentions Ruby 2.0.0)

### 💡 Optional Improvements
- String formatting: `'[%s] -- %s' % [time, message]` → `"[#{time}] -- #{message}"`
- Add `.ruby-version` file for consistency
- Add basic tests (currently NO tests exist)

## Files Requiring Changes

### Must Modify:
1. `versacommerce-cli.gemspec` (lines 21, 23-31)
   - Update required_ruby_version
   - Update all dependencies

2. `lib/versacommerce/cli/theme.rb` (lines 160, 166, 173)
   - Fix YAML.load_file security issue

3. `README.md` (line 9)
   - Update Ruby version requirement

### Should Create:
4. `.ruby-version` (optional but recommended)
   - Ensures consistent Ruby version across environments

## Ruby 2.6.9 → 3.3 Breaking Changes Impact

| Change | Impact | Action Required |
|--------|--------|-----------------|
| Keyword arguments separation | ✅ None | Already using correct syntax |
| YAML.load deprecation | 🚨 High | Must fix 3 instances |
| Hash behavior changes | ✅ None | Using modern syntax |
| String/Symbol handling | ✅ None | No issues found |
| Integer division | ✅ None | Not used in code |
| Pattern matching | ✅ None | Not used |

## Testing Strategy

### Current Test Coverage: **0%**
- No `/test` directory
- No `/spec` directory
- No CI/CD configuration
- **Risk**: No automated validation of changes

### Manual Testing Required:
1. **Install dependencies**: `bundle install` with new Gemfile.lock
2. **CLI help commands**: Test all `--help` outputs
3. **Config loading**: Test all 5 authorization methods
4. **File operations**: Test download/upload/watch if possible

### Testing Commands:
```bash
# Basic functionality
bundle exec vc-theme --help
bundle exec vc-theme download --help
bundle exec vc-theme watch --help
bundle exec vc-theme upload --help

# Config file loading (all 5 auth methods)
bundle exec vc-theme download --authorization=TEST_AUTH
bundle exec vc-theme download --config=/tmp/test-config.yml
cd /tmp && echo "authorization: TEST" > config.yml && bundle exec vc-theme download
THEME_AUTHORIZATION=TEST bundle exec vc-theme download
mkdir -p ~/.config/versacommerce/cli && echo "authorization: TEST" > ~/.config/versacommerce/cli/config.yml

# Check for warnings
ruby -w exe/vc-theme --help
```

## Known Risks & Blockers

### HIGH RISK:
1. **versacommerce-theme_api_client dependency** - Unknown compatibility (POTENTIAL BLOCKER)
2. **No test coverage** - Manual testing only, risk of regression
3. **Thor 0.19.1 → 1.3** - Major version jump, API may have changed

### MEDIUM RISK:
1. **Listen 2.10 → 3.9** - File watching behavior may differ
2. **YAML permitted_classes** - May break if configs use unexpected classes
3. **Bundler constraints** - Need to allow both 1.x and 2.x

### LOW RISK:
1. **Colorize, Rake, Pry updates** - Should be backward compatible
2. **Documentation updates** - Simple text changes

## Dependency Investigation Needed

### versacommerce-theme_api_client
**Action**: Must verify Ruby 3.3 compatibility before proceeding

```bash
# Check gem metadata
gem fetch versacommerce-theme_api_client -v 0.1.3
tar -xzf versacommerce-theme_api_client-0.1.3.gem
tar -xzf data.tar.gz
cat versacommerce-theme_api_client.gemspec | grep required_ruby_version

# Or check online
gem info versacommerce-theme_api_client --remote
```

**If incompatible**: This becomes a blocker and requires either:
- Upgrading that gem first (if we control it)
- Finding alternative API client
- Staying on Ruby 2.6/2.7 until fixed

## Implementation Approach

### Phase 1: Investigation ✓
- [x] Analyze current codebase
- [x] Identify dependencies
- [x] Find breaking changes
- [ ] **Verify versacommerce-theme_api_client compatibility**

### Phase 2: Core Updates
1. Update gemspec Ruby requirement
2. Update all dependency versions
3. Fix YAML security issues
4. Update README

### Phase 3: Testing
1. Remove Gemfile.lock
2. Run bundle install
3. Execute manual test suite
4. Check for Ruby warnings

### Phase 4: Documentation
1. Update README.md
2. Add .ruby-version (optional)
3. Update CLAUDE.md
4. Document any behavior changes

## Testing Instructions

After implementation, perform these tests:

### 1. Dependency Installation
```bash
rm -f Gemfile.lock
bundle install
# Should complete without errors
```

### 2. Basic CLI Functionality
```bash
bundle exec vc-theme --help
# Should show help without errors or warnings

bundle exec vc-theme download --help
bundle exec vc-theme watch --help
bundle exec vc-theme upload --help
# All should display help text
```

### 3. Config File Loading (5 methods)
```bash
# Method 1: Direct authorization flag
bundle exec vc-theme download --authorization=dummy_auth --path=/tmp/test1
# Should fail with API error (not config error)

# Method 2: Explicit config file
echo "authorization: test_auth" > /tmp/test-config.yml
bundle exec vc-theme download --config=/tmp/test-config.yml --path=/tmp/test2
# Should attempt to connect to API

# Method 3: Implicit pwd config
cd /tmp/test-dir
echo "authorization: test_auth" > config.yml
bundle exec vc-theme download --path=/tmp/test3
# Should load from ./config.yml

# Method 4: Environment variable
THEME_AUTHORIZATION=test_auth bundle exec vc-theme download --path=/tmp/test4
# Should use env var

# Method 5: Global config
mkdir -p ~/.config/versacommerce/cli
echo "authorization: test_auth" > ~/.config/versacommerce/cli/config.yml
bundle exec vc-theme download --path=/tmp/test5
# Should load from global config
```

### 4. YAML Security Test
```bash
# Create a config with Symbol keys
echo ":authorization: test_value" > /tmp/symbol-config.yml
bundle exec vc-theme download --config=/tmp/symbol-config.yml
# Should work without errors (permitted_classes: [Symbol])
```

### 5. Ruby Warnings Check
```bash
ruby -w exe/vc-theme --help 2>&1 | grep -i warning
# Should not show YAML.load_file warnings
```

### 6. Build & Install Test
```bash
rake build
gem install pkg/versacommerce-cli-0.2.3.gem
vc-theme --help
# Should work as standalone gem
```

## Success Criteria

- [ ] All dependencies install successfully with Ruby 3.3
- [ ] versacommerce-theme_api_client is compatible or updated
- [ ] No YAML.load_file deprecation warnings
- [ ] All CLI commands show help correctly
- [ ] Config loading works for all 5 methods
- [ ] No Ruby warnings when running with -w flag
- [ ] Gem builds successfully
- [ ] README reflects Ruby 3.3 requirement

## Open Questions

1. **Backward Compatibility**: Should we maintain Ruby 2.x support or hard require 3.3+?
2. **Version Pinning**: Use exact versions (~> 1.3) or ranges (>= 1.3, < 2.0)?
3. **versacommerce-theme_api_client**: Can we test/verify compatibility? Do we control this gem?
4. **.ruby-version file**: Should we add this for developer consistency?
5. **Test Suite**: Should basic tests be added as part of this upgrade?
6. **Version Bump**: Should gem version be bumped (0.2.3 → 0.3.0) due to Ruby requirement change?

## Existing Patterns to Follow

### Logging Pattern
```ruby
logger.info('Message')
logger.debug('Debug message')  # Only shown with --verbose
logger.success('Success message')  # Green color
logger.error('Error message')  # Red color
```

### Thor CLI Pattern
```ruby
class_option :option_name, aliases: :o, type: :boolean
option :command_option, default: value
def command_name
  # Implementation
end
```

### Error Handling Pattern
```ruby
unless condition
  logger.error('Error message')
  exit 1
end
```

### File Operations Pattern
```ruby
path = Pathname.new(options[:path]).expand_path
FileUtils.mkdir_p(path)
File.open(path, 'wb') { |f| f.write(content) }
```

## Additional Context

- User is running Ruby 3.1.3 currently
- No test infrastructure exists
- Gem is actively maintained (last commit: version bump to 0.2.3)
- CLI is customer-facing tool (breaking changes impact users)
- Git repository is clean (no uncommitted changes)

---

**Document Created**: 2025-10-29
**Last Updated**: 2025-10-29
**Task Status**: Planning phase
