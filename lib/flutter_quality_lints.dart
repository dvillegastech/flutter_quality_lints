/// A collection of custom linting rules for Flutter projects
/// that enhance code quality and maintainability.

library flutter_quality_lints;

import 'package:flutter_quality_lints/src/rules/base_lint_rule.dart';
import 'package:flutter_quality_lints/src/rules/avoid_late_keyword.dart';
import 'package:flutter_quality_lints/src/rules/prefer_const_widgets.dart';
import 'package:flutter_quality_lints/src/rules/avoid_hardcoded_strings.dart';
import 'package:flutter_quality_lints/src/rules/maximum_lines_per_file.dart';
import 'package:flutter_quality_lints/src/rules/prefer_named_parameters.dart';
import 'package:flutter_quality_lints/src/rules/avoid_nested_conditionals.dart';
import 'package:flutter_quality_lints/src/rules/prefer_early_return.dart';
import 'package:flutter_quality_lints/src/rules/avoid_magic_numbers.dart';
import 'package:flutter_quality_lints/src/rules/prefer_single_widget_per_file.dart';
import 'package:flutter_quality_lints/src/rules/avoid_long_methods.dart';
import 'package:flutter_quality_lints/src/rules/prefer_trailing_commas.dart';
import 'package:flutter_quality_lints/src/rules/avoid_empty_catch_blocks.dart';

// Core rules
export 'src/rules/avoid_late_keyword.dart';
export 'src/rules/prefer_const_widgets.dart';
export 'src/rules/avoid_hardcoded_strings.dart';
export 'src/rules/maximum_lines_per_file.dart';
export 'src/rules/prefer_named_parameters.dart';

// Advanced code quality rules
export 'src/rules/avoid_nested_conditionals.dart';
export 'src/rules/prefer_early_return.dart';
export 'src/rules/avoid_magic_numbers.dart';
export 'src/rules/prefer_single_widget_per_file.dart';
export 'src/rules/avoid_long_methods.dart';
export 'src/rules/prefer_trailing_commas.dart';
export 'src/rules/avoid_empty_catch_blocks.dart';

/// The main configuration class that exports all linting rules
class FlutterQualityLints {
  /// Returns a list of all available linting rules for core functionality
  static List<LintRule> get coreRules => [
        const AvoidLateKeyword(),
        const PreferConstWidgets(),
        const AvoidHardcodedStrings(),
        const MaximumLinesPerFile(),
        const PreferNamedParameters(),
      ];

  /// Returns a list of advanced code quality rules
  static List<LintRule> get advancedRules => [
        const AvoidNestedConditionals(),
        const PreferEarlyReturn(),
        const AvoidMagicNumbers(),
        const PreferSingleWidgetPerFile(),
        const AvoidLongMethods(),
        const PreferTrailingCommas(),
        const AvoidEmptyCatchBlocks(),
      ];

  /// Returns a list of all available linting rules
  static List<LintRule> get allRules => [
        ...coreRules,
        ...advancedRules,
      ];

  /// Returns a list of recommended rules for most projects
  static List<LintRule> get recommendedRules => [
        const AvoidLateKeyword(),
        const PreferConstWidgets(),
        const AvoidHardcodedStrings(),
        const PreferNamedParameters(),
        const AvoidNestedConditionals(),
        const AvoidMagicNumbers(),
        const AvoidLongMethods(),
        const AvoidEmptyCatchBlocks(),
      ];

  /// Legacy getter for backward compatibility
  @Deprecated('Use allRules instead')
  static List<LintRule> get rules => allRules;
}
