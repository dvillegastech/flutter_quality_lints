<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Quality Lints

A comprehensive package of custom linting rules for Flutter projects that significantly improves code quality and maintainability.

## Features

- 12 specialized linting rules for Flutter and Dart
- Organized categories: Core rules and advanced rules
- Flexible configuration: Use all rules or only recommended ones
- Easy integration with existing projects
- Clear error messages with improvement suggestions

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_quality_lints: ^0.0.1
  custom_lint: ^0.5.8
```

Then run:

```bash
dart pub get
```

## Configuration

Create an `analysis_options.yaml` file in your project root:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Use all rules
    - flutter_quality_lints
```

## Available Rules

### Core Rules

#### `avoid_late_keyword`
- **Description**: Discourages the use of the `late` keyword
- **Benefit**: Prevents runtime errors
- **Example**:
```dart
// Avoid
late String name;

// Prefer
String? name;
```

#### `prefer_const_widgets`
- **Description**: Encourages the use of const constructors in widgets
- **Benefit**: Improves performance
- **Example**:
```dart
// Avoid
Text('Hello World')

// Prefer
const Text('Hello World')
```

#### `avoid_hardcoded_strings`
- **Description**: Prevents hardcoded strings in widgets
- **Benefit**: Promotes localization
- **Example**:
```dart
// Avoid
Text('Hello World')

// Prefer
Text(AppLocalizations.of(context).hello)
```

#### `maximum_lines_per_file`
- **Description**: Limits the number of lines per file (max 300)
- **Benefit**: Improves readability and maintainability

#### `prefer_named_parameters`
- **Description**: Encourages the use of named parameters
- **Benefit**: Improves code readability
- **Example**:
```dart
// Avoid
void createUser(String name, int age, bool isActive) {}

// Prefer
void createUser({
  required String name,
  required int age,
  required bool isActive,
}) {}
```

### Advanced Rules

#### `avoid_nested_conditionals`
- **Description**: Prevents deeply nested conditional statements (max 3 levels)
- **Benefit**: Improves code readability
- **Example**:
```dart
// Avoid
if (user != null) {
  if (user.isActive) {
    if (user.hasPermission) {
      if (user.isVerified) {
        // too deeply nested
      }
    }
  }
}

// Prefer
if (user == null) return;
if (!user.isActive) return;
if (!user.hasPermission) return;
if (!user.isVerified) return;
// main logic
```

#### `prefer_early_return`
- **Description**: Encourages the use of early returns
- **Benefit**: Reduces complexity and improves readability

#### `avoid_magic_numbers`
- **Description**: Prevents magic numbers in code
- **Benefit**: Improves readability and maintainability
- **Example**:
```dart
// Avoid
Container(height: 48, width: 320)

// Prefer
const double buttonHeight = 48;
const double buttonWidth = 320;
Container(height: buttonHeight, width: buttonWidth)
```

#### `prefer_single_widget_per_file`
- **Description**: Encourages one widget per file
- **Benefit**: Improves code organization

#### `avoid_long_methods`
- **Description**: Prevents overly long methods (max 50 lines)
- **Benefit**: Improves readability and maintainability

#### `prefer_trailing_commas`
- **Description**: Encourages the use of trailing commas
- **Benefit**: Improves version control and formatting

#### `avoid_empty_catch_blocks`
- **Description**: Prevents empty catch blocks
- **Benefit**: Improves error handling
- **Example**:
```dart
// Avoid
try {
  riskyOperation();
} catch (e) {
  // empty block
}

// Prefer
try {
  riskyOperation();
} catch (e) {
  logger.error('Error in risky operation', e);
  // or rethrow if necessary
}
```

## Preset Configurations

### All Rules
```dart
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

final rules = FlutterQualityLints.allRules;
```

### Core Rules Only
```dart
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

final rules = FlutterQualityLints.coreRules;
```

### Recommended Rules
```dart
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

final rules = FlutterQualityLints.recommendedRules;
```

## Development

To contribute to package development:

```bash
# Clone the repository
git clone https://github.com/yourusername/flutter_quality_lints.git

# Install dependencies
cd flutter_quality_lints
dart pub get

# Run tests
flutter test

# Run analysis
dart analyze
```

## Statistics

- 12 specialized linting rules
- 100% test coverage with unit tests
- Complete documentation with examples
- Easy configuration and integration

## Contributing

Contributions are welcome. Please:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Support

If you have questions or need help:

- Open an [issue](https://github.com/dvillegastech/flutter_quality_lints/issues)
- Contact the maintainer

---

**Improve your Flutter code quality with these specialized rules!**
