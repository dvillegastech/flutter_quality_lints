# Flutter Quality Lints

<a href="https://coff.ee/dvillegas" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="150" />
</a>


A comprehensive, enterprise-grade linting package for Flutter projects that ensures code quality, performance, security, and accessibility compliance.

## Features

### Core Quality Rules (7 rules)
- **avoid_empty_catch_blocks** - Prevents silent error swallowing
- **avoid_long_methods** - Enforces method length limits (default: 50 lines)
- **avoid_magic_numbers** - Requires constants for hardcoded numbers
- **avoid_nested_conditionals** - Limits conditional nesting depth
- **prefer_early_return** - Encourages guard clauses
- **prefer_single_widget_per_file** - Promotes better organization
- **prefer_trailing_commas** - Ensures consistent formatting

### Flutter Performance Rules (4 rules)
- **prefer_slivers_over_columns** - Optimizes scrolling performance for long lists
- **avoid_widget_rebuilds** - Detects unnecessary widget rebuilds
- **prefer_stateless_widgets** - Suggests StatelessWidget when appropriate
- **avoid_build_context_across_async** - Prevents common async context errors

### Architecture Rules (1 rule)
- **enforce_layer_dependencies** - Validates clean architecture layer dependencies

### Security Rules (1 rule)
- **avoid_hardcoded_secrets** - Detects API keys, passwords, and other secrets

### Advanced CLI Tool
- **Comprehensive Analysis** - Multi-dimensional code quality assessment
- **Performance Profiling** - Widget tree optimization and memory leak detection
- **Security Scanning** - Vulnerability assessment and secret detection
- **Accessibility Compliance** - WCAG guidelines validation
- **Interactive Reports** - HTML/JSON/Markdown report generation

## Installation

Add this to your package's `pubspec.yaml`:

```yaml
dev_dependencies:
  custom_lint: ^0.6.4
  flutter_quality_lints: ^0.9.1
```

## Configuration

### Basic Setup

Create or update your `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Recommended preset (10 rules)
    - avoid_empty_catch_blocks
    - avoid_magic_numbers
    - prefer_early_return
    - prefer_trailing_commas
    - avoid_widget_rebuilds
    - prefer_stateless_widgets
    - avoid_build_context_across_async
    - avoid_hardcoded_secrets
    - enforce_layer_dependencies
    - prefer_slivers_over_columns
```

### Rule Presets

Choose from predefined rule sets:

```dart
// In your custom_lint.yaml or analysis_options.yaml
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

// Available presets:
FlutterQualityLints.basicRules        // 5 essential rules
FlutterQualityLints.recommendedRules  // 10 production-ready rules
FlutterQualityLints.strictRules       // All 13 rules
FlutterQualityLints.performanceRules  // 4 performance-focused rules
FlutterQualityLints.securityRules     // 1 security rule
```

### Advanced Configuration

```yaml
flutter_quality_lints:
  # Core Rules Configuration
  avoid_long_methods:
    max_lines: 50
    exclude_getters: true
    exclude_constructors: true
  
  avoid_magic_numbers:
    allowed_numbers: [0, 1, -1, 2, 10, 100, 1000]
    ignore_in_tests: true
  
  # Performance Rules Configuration
  prefer_slivers_over_columns:
    max_children: 10
    check_scrollable_nesting: true
  
  avoid_widget_rebuilds:
    check_const_usage: true
    check_inline_functions: true
  
  # Architecture Rules Configuration
  enforce_layer_dependencies:
    layers:
      presentation: ["lib/presentation/", "lib/ui/", "lib/pages/"]
      domain: ["lib/domain/", "lib/entities/", "lib/usecases/"]
      data: ["lib/data/", "lib/datasources/", "lib/models/"]
    
    dependency_rules:
      presentation: ["domain"]  # Can only depend on domain
      domain: []                # Pure - no dependencies
      data: ["domain"]          # Can only depend on domain
  
  # Security Rules Configuration
  avoid_hardcoded_secrets:
    min_secret_length: 10
    ignore_test_files: true
    check_patterns:
      - api_keys
      - jwt_tokens
      - oauth_tokens
```

## CLI Tool Usage

The Flutter Quality Lints CLI provides advanced analysis capabilities:

### Installation

```bash
# Add to pubspec.yaml
dependencies:
  flutter_quality_lints: ^0.9.1

# Make CLI executable
chmod +x bin/flutter_quality_lints.dart
```

### Commands

#### Comprehensive Analysis
```bash
dart bin/flutter_quality_lints.dart analyze [target_directory]

# Example output:
# Running Flutter Quality Analysis on: lib
# Analysis Results:
# Files analyzed: 25
# Issues found: 12
# Critical: 2
# Warning: 7
# Info: 3
# Quality Score: 9.5/10.0
```

#### Performance Analysis
```bash
dart bin/flutter_quality_lints.dart performance [target_directory]

# Features:
# Widget Tree Complexity Analysis
# Memory Leak Detection
# Unnecessary Rebuild Detection
# Performance Score Calculation
```

#### Optimization Suggestions
```bash
dart bin/flutter_quality_lints.dart optimize [target_directory]

# Provides:
# Widget Optimizations
# State Management Improvements
# Build Context Safety Recommendations
```

#### Security Scanning
```bash
dart bin/flutter_quality_lints.dart security [target_directory]

# Detects:
# Hardcoded Secrets (API keys, passwords)
# Input Validation Issues
# Insecure Network Connections
```

#### Accessibility Compliance
```bash
dart bin/flutter_quality_lints.dart accessibility [target_directory]

# Validates:
# WCAG AA Compliance
# Semantic Labels
# Color Contrast Ratios
# Focus Management
```

#### Report Generation
```bash
dart bin/flutter_quality_lints.dart report [html|json|markdown]

# Generates:
# Comprehensive Quality Reports
# Trend Analysis Charts
# Interactive Navigation
# Export to PDF (HTML format)
```

#### Auto-Fix Engine
```bash
# Preview fixes without applying them
dart bin/flutter_quality_lints.dart fix [target_directory] --dry-run

# Apply automatic fixes
dart bin/flutter_quality_lints.dart fix [target_directory]

# Auto-fixes include:
# - Add const to widget constructors
# - Add trailing commas
# - Convert to StatelessWidget
# - Add mounted checks after async
# - Simplify nested conditionals
# - Extract magic numbers to constants
```

## Rule Details

### Core Quality Rules

#### avoid_magic_numbers
```dart
// Bad
Container(width: 250, height: 150);

// Good
class Constants {
  static const double cardWidth = 250;
  static const double cardHeight = 150;
}
Container(width: Constants.cardWidth, height: Constants.cardHeight);
```

#### prefer_early_return
```dart
// Bad
String processUser(User? user) {
  if (user != null) {
    if (user.isActive) {
      return user.name;
    } else {
      return 'Inactive user';
    }
  } else {
    return 'No user';
  }
}

// Good
String processUser(User? user) {
  if (user == null) return 'No user';
  if (!user.isActive) return 'Inactive user';
  return user.name;
}
```

### Performance Rules

#### prefer_slivers_over_columns
```dart
// Bad - Performance issue with many children
Column(
  children: List.generate(1000, (index) => Text('Item $index')),
)

// Good - Efficient scrolling
CustomScrollView(
  slivers: [
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Text('Item $index'),
        childCount: 1000,
      ),
    ),
  ],
)
```

#### avoid_build_context_across_async
```dart
// Bad - Context used after async operation
Future<void> deleteItem() async {
  await apiService.deleteItem();
  Navigator.of(context).pop(); // Dangerous!
}

// Good - Check if mounted
Future<void> deleteItem() async {
  await apiService.deleteItem();
  if (mounted) {
    Navigator.of(context).pop();
  }
}
```

### Security Rules

#### avoid_hardcoded_secrets
```dart
// Bad
const String apiKey = 'sk_live_abcd1234567890';

// Good
final String apiKey = Platform.environment['API_KEY'] ?? '';
```

### Architecture Rules

#### enforce_layer_dependencies
```dart
// Bad - Presentation layer importing data layer
import '../data/user_repository_impl.dart'; // In presentation layer

// Good - Presentation layer importing domain layer
import '../domain/repositories/user_repository.dart'; // In presentation layer
```

## Quality Metrics

The package provides comprehensive quality scoring:

- **Quality Score**: Overall code health (0-10.0)
- **Performance Score**: Widget and rendering efficiency
- **Security Score**: Vulnerability assessment
- **Accessibility Score**: WCAG compliance level

### Scoring Algorithm
```
Quality Score = 10.0 - (Critical Issues × 2.0 + Warnings × 1.0 + Info × 0.5) / Files Analyzed
```

## Integration Examples

### CI/CD Integration
```yaml
# .github/workflows/quality_check.yml
- name: Run Quality Analysis
  run: |
    dart bin/flutter_quality_lints.dart analyze lib
    dart bin/flutter_quality_lints.dart security lib
    dart bin/flutter_quality_lints.dart report json > quality_report.json
```

### VS Code Integration
```json
{
  "dart.customLintRules": ["flutter_quality_lints"],
  "dart.showIgnoreQuickFixes": true
}
```

### Pre-commit Hook
```bash
#!/bin/sh
dart bin/flutter_quality_lints.dart analyze lib
if [ $? -ne 0 ]; then
  echo "Quality check failed. Please fix issues before committing."
  exit 1
fi
```

## Advanced Features

### Native Analysis Options Integration
Full integration with Dart's built-in analyzer for comprehensive coverage.

### Auto-fix Engine
Many rules support automatic fixes for common patterns.

### Performance Profiling
Deep analysis of widget trees and rebuild patterns.

### Security Scanning
Enterprise-grade secret detection with pattern matching.

### Accessibility Validation
WCAG 2.1 AA compliance checking with actionable recommendations.

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
```bash
git clone https://github.com/dvillegastech/flutter_quality_lints.git
cd flutter_quality_lints
dart pub get
dart test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- [Documentation](https://pub.dev/packages/flutter_quality_lints)
- [Issue Tracker](https://github.com/dvillegastech/flutter_quality_lints/issues)
- [Changelog](CHANGELOG.md)

---

**Made with by [David Villegas](https://github.com/dvillegastech)**
