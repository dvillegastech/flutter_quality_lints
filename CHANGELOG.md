# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.1] - 2025-01-28

### Added
- **Auto-Fix Engine**: Automatic code correction engine with 6 intelligent fix types
- **CLI `fix` command**: New command for applying automatic code corrections
  - Dry-run mode to preview changes without applying them
  - Processing of individual files or complete directories
  - Automatic filtering of generated files
- **Programmatic API** for Auto-Fix Engine integration in custom tools
- **Complete example** of Auto-Fix Engine usage in `example/auto_fix_example.dart`

### Available Auto-Fixes
1. **AddConstToWidgetFix**: Adds `const` to widget constructors when possible
2. **AddTrailingCommaFix**: Adds trailing commas for better code formatting
3. **ConvertToStatelessWidgetFix**: Converts StatefulWidget to StatelessWidget when appropriate
4. **AddMountedCheckFix**: Adds `mounted` checks after async operations
5. **SimplifyConditionalFix**: Simplifies nested conditionals (prepared for expansion)
6. **RemoveMagicNumberFix**: Extracts magic numbers to constants (prepared for expansion)

### Improved
- **Updated documentation** with Auto-Fix Engine usage examples
- **Enhanced CLI** with new command and advanced options
- **Fixed example** with explicit types and better logging practices

### Technical
- Syntactic analysis before applying corrections
- Safe processing with file validation
- Detailed metrics of fixes applied per file
- Complete integration with existing linting system

## [0.9.0] - 2025-01-28

### Added

#### New Rule Categories
- Flutter Performance Rules (4 new rules):
  - prefer_slivers_over_columns - Optimizes scrolling performance for long lists
  - avoid_widget_rebuilds - Detects unnecessary widget rebuilds  
  - prefer_stateless_widgets - Suggests StatelessWidget when appropriate
  - avoid_build_context_across_async - Prevents common async context errors

- Architecture Rules (1 new rule):
  - enforce_layer_dependencies - Validates clean architecture layer dependencies

- Security Rules (1 new rule):
  - avoid_hardcoded_secrets - Detects API keys, passwords, and other secrets

#### Advanced CLI Tool
- Comprehensive analysis engine with quality scoring (0-10.0 scale)
- Performance profiling: widget tree analysis, memory leak detection, rebuild detection
- Security scanning: secret detection, vulnerability assessment, input validation checking
- Accessibility compliance: WCAG 2.1 AA validation, semantic labels, color contrast
- Report generation: HTML, JSON, and Markdown formats with interactive features
- Auto-Fix Engine: Automatic code correction with 6 intelligent fixes

#### Enhanced Configuration
- Rule presets: basicRules, recommendedRules, strictRules, performanceRules, securityRules
- Native analysis_options.yaml integration
- Advanced rule configuration with customizable parameters
- Support for rule-specific settings and exclusions

#### CLI Commands
- analyze - Comprehensive code quality analysis
- performance - Performance bottleneck detection and widget optimization
- optimize - Code optimization suggestions with auto-fix capabilities
- security - Security vulnerability scanning and secret detection
- accessibility - WCAG compliance checking and usability validation
- report - Interactive report generation in multiple formats
- fix - Automatic code fixing with dry-run mode and selective application

### Changed
- Reorganized rule structure into logical categories (Core, Performance, Architecture, Security)
- Improved rule execution performance and memory usage
- Enhanced error messages with actionable suggestions
- Updated documentation with comprehensive examples and integration guides

### Improved
- Quality scoring algorithm with detailed metrics
- Analysis accuracy with reduced false positives
- Better handling of complex Flutter/Dart patterns
- Cross-platform compatibility

### Configuration
- Configurable method length limits (default: 50 lines)
- Customizable magic number allowlists
- Adjustable conditional nesting depth limits
- Widget count thresholds for performance rules
- Layer dependency mapping for architecture validation
- Secret detection patterns and safe value filtering

### Statistics
- Total rules: 13 comprehensive linting rules
- Rule categories: 4 distinct categories (Core, Performance, Architecture, Security)
- CLI commands: 6 specialized analysis commands
- Configuration options: 20+ customizable parameters
- Test coverage: Complete unit test suite
- Documentation: Comprehensive with examples and integration guides

## [0.0.1] - 2025-01-15

### Added
- Initial release of Flutter Quality Lints package
- Core linting rules (7 rules):
  - avoid_empty_catch_blocks - Prevents silent error handling
  - avoid_long_methods - Enforces method length limits
  - avoid_magic_numbers - Requires constants for hardcoded numbers
  - avoid_nested_conditionals - Limits conditional nesting depth
  - prefer_early_return - Encourages guard clauses and early returns
  - prefer_single_widget_per_file - Promotes better code organization
  - prefer_trailing_commas - Ensures consistent code formatting

### Features
- Custom lint integration with Flutter/Dart analyzer
- Flexible rule configuration system
- Rule categorization and preset configurations
- Comprehensive error messages with improvement suggestions
- Easy installation and setup process
- Complete documentation with usage examples

### Technical Implementation
- Base LintRule class for consistent rule implementation
- AST (Abstract Syntax Tree) analysis for accurate code inspection
- Integration with custom_lint package for seamless IDE support
- Comprehensive test suite with 100% coverage
- Modular architecture for easy rule addition and maintenance
