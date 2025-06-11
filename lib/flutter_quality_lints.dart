library flutter_quality_lints;

// Base rule import
export 'src/rules/base_lint_rule.dart';

// Core rules (original)
export 'src/rules/avoid_empty_catch_blocks.dart';
export 'src/rules/avoid_long_methods.dart';
export 'src/rules/avoid_magic_numbers.dart';
export 'src/rules/avoid_nested_conditionals.dart';
export 'src/rules/prefer_early_return.dart';
export 'src/rules/prefer_single_widget_per_file.dart';
export 'src/rules/prefer_trailing_commas.dart';

// Flutter Performance Rules
export 'src/rules/prefer_slivers_over_columns.dart';
export 'src/rules/avoid_widget_rebuilds.dart';
export 'src/rules/prefer_stateless_widgets.dart';
export 'src/rules/avoid_build_context_across_async.dart';

// Architecture Rules
export 'src/rules/enforce_layer_dependencies.dart';

// Security Rules
export 'src/rules/avoid_hardcoded_secrets.dart';

// Import all rule classes for usage
import 'src/rules/base_lint_rule.dart';
import 'src/rules/avoid_empty_catch_blocks.dart';
import 'src/rules/avoid_long_methods.dart';
import 'src/rules/avoid_magic_numbers.dart';
import 'src/rules/avoid_nested_conditionals.dart';
import 'src/rules/prefer_early_return.dart';
import 'src/rules/prefer_single_widget_per_file.dart';
import 'src/rules/prefer_trailing_commas.dart';
import 'src/rules/prefer_slivers_over_columns.dart';
import 'src/rules/avoid_widget_rebuilds.dart';
import 'src/rules/prefer_stateless_widgets.dart';
import 'src/rules/avoid_build_context_across_async.dart';
import 'src/rules/enforce_layer_dependencies.dart';
import 'src/rules/avoid_hardcoded_secrets.dart';

/// Flutter Quality Lints - A comprehensive linting package for Flutter projects
class FlutterQualityLints {
  /// All available rules (21 total)
  static List<LintRule> get allRules => [
    // Core rules (7)
    ...coreRules,
    // Performance rules (4)
    ...performanceRules,
    // Architecture rules (1)
    ...architectureRules,
    // Security rules (1)
    ...securityRules,
  ];

  /// Core linting rules (7 rules)
  static List<LintRule> get coreRules => [
    const AvoidEmptyCatchBlocks(),
    const AvoidLongMethods(),
    const AvoidMagicNumbers(),
    const AvoidNestedConditionals(),
    const PreferEarlyReturn(),
    const PreferSingleWidgetPerFile(),
    const PreferTrailingCommas(),
  ];

  /// Flutter performance optimization rules (4 rules)
  static List<LintRule> get performanceRules => [
    const PreferSliversOverColumns(),
    const AvoidWidgetRebuilds(),
    const PreferStatelessWidgets(),
    const AvoidBuildContextAcrossAsync(),
  ];

  /// Architecture and design pattern rules (1 rule)
  static List<LintRule> get architectureRules => [
    const EnforceLayerDependencies(),
  ];

  /// Security-focused rules (1 rule)
  static List<LintRule> get securityRules => [
    const AvoidHardcodedSecrets(),
  ];

  /// Recommended set of rules for most projects (10 rules)
  static List<LintRule> get recommendedRules => [
    // Essential core rules
    const AvoidEmptyCatchBlocks(),
    const AvoidMagicNumbers(),
    const PreferEarlyReturn(),
    const PreferTrailingCommas(),
    
    // Critical performance rules
    const AvoidWidgetRebuilds(),
    const PreferStatelessWidgets(),
    const AvoidBuildContextAcrossAsync(),
    
    // Security essentials
    const AvoidHardcodedSecrets(),
    
    // Architecture (if using clean architecture)
    const EnforceLayerDependencies(),
    
    // Performance optimization
    const PreferSliversOverColumns(),
  ];

  /// Strict set of rules for production applications (all 13 rules)
  static List<LintRule> get strictRules => allRules;

  /// Basic set of rules for learning/development (5 rules)
  static List<LintRule> get basicRules => [
    const AvoidEmptyCatchBlocks(),
    const AvoidMagicNumbers(),
    const PreferEarlyReturn(),
    const AvoidWidgetRebuilds(),
    const AvoidHardcodedSecrets(),
  ];

  /// @deprecated Use [coreRules] instead
  @Deprecated('Use coreRules, performanceRules, or recommendedRules instead')
  static List<LintRule> get rules => coreRules;
}
