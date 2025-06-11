import 'package:flutter_quality_lints/src/rules/avoid_hardcoded_strings.dart';
import 'package:flutter_quality_lints/src/rules/avoid_late_keyword.dart';
import 'package:flutter_quality_lints/src/rules/maximum_lines_per_file.dart';
import 'package:flutter_quality_lints/src/rules/prefer_const_widgets.dart';
import 'package:flutter_quality_lints/src/rules/prefer_named_parameters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

void main() {
  group('Flutter Quality Lints Tests', () {
    group('Core Rules', () {
      test('AvoidLateKeyword rule should be instantiable', () {
        const rule = AvoidLateKeyword();
        expect(rule.ruleName, equals('avoid_late_keyword'));
        expect(rule.message, contains('Avoid using the late keyword'));
        expect(rule.description, contains('late keyword'));
      });

      test('PreferNamedParameters rule should be instantiable', () {
        const rule = PreferNamedParameters();
        expect(rule.ruleName, equals('prefer_named_parameters'));
        expect(rule.message, contains('named parameters'));
        expect(rule.description, contains('readability'));
      });

      test('AvoidHardcodedStrings rule should be instantiable', () {
        const rule = AvoidHardcodedStrings();
        expect(rule.ruleName, equals('avoid_hardcoded_strings'));
        expect(rule.message, contains('hardcoded strings'));
        expect(rule.description, contains('localization'));
      });

      test('MaximumLinesPerFile rule should be instantiable', () {
        const rule = MaximumLinesPerFile();
        expect(rule.ruleName, equals('maximum_lines_per_file'));
        expect(rule.message, contains('maximum'));
        expect(rule.description, contains('maintainability'));
      });

      test('PreferConstWidgets rule should be instantiable', () {
        const rule = PreferConstWidgets();
        expect(rule.ruleName, equals('prefer_const_widgets'));
        expect(rule.message, contains('const constructors'));
        expect(rule.description, contains('performance'));
      });
    });

    group('Advanced Rules', () {
      test('AvoidNestedConditionals rule should be instantiable', () {
        const rule = AvoidNestedConditionals();
        expect(rule.ruleName, equals('avoid_nested_conditionals'));
        expect(rule.message, contains('nested conditional'));
        expect(rule.description, contains('readability'));
      });

      test('PreferEarlyReturn rule should be instantiable', () {
        const rule = PreferEarlyReturn();
        expect(rule.ruleName, equals('prefer_early_return'));
        expect(rule.message, contains('early return'));
        expect(rule.description, contains('nesting'));
      });

      test('AvoidMagicNumbers rule should be instantiable', () {
        const rule = AvoidMagicNumbers();
        expect(rule.ruleName, equals('avoid_magic_numbers'));
        expect(rule.message, contains('magic numbers'));
        expect(rule.description, contains('readability'));
      });

      test('PreferSingleWidgetPerFile rule should be instantiable', () {
        const rule = PreferSingleWidgetPerFile();
        expect(rule.ruleName, equals('prefer_single_widget_per_file'));
        expect(rule.message, contains('one widget'));
        expect(rule.description, contains('organizing'));
      });

      test('AvoidLongMethods rule should be instantiable', () {
        const rule = AvoidLongMethods();
        expect(rule.ruleName, equals('avoid_long_methods'));
        expect(rule.message, contains('too long'));
        expect(rule.description, contains('maintainability'));
      });

      test('PreferTrailingCommas rule should be instantiable', () {
        const rule = PreferTrailingCommas();
        expect(rule.ruleName, equals('prefer_trailing_commas'));
        expect(rule.message, contains('trailing comma'));
        expect(rule.description, contains('trailing commas'));
      });

      test('AvoidEmptyCatchBlocks rule should be instantiable', () {
        const rule = AvoidEmptyCatchBlocks();
        expect(rule.ruleName, equals('avoid_empty_catch_blocks'));
        expect(rule.message, contains('empty catch'));
        expect(rule.description, contains('exceptions'));
      });
    });

    group('Rule Collections', () {
      test('All rules have unique rule names', () {
        final allRules = FlutterQualityLints.allRules;
        final ruleNames = allRules.map((rule) => rule.ruleName).toList();
        final uniqueNames = ruleNames.toSet();
        
        expect(uniqueNames.length, equals(ruleNames.length),
            reason: 'All rules should have unique names');
      });

      test('All rules have non-empty messages and descriptions', () {
        final allRules = FlutterQualityLints.allRules;

        for (final rule in allRules) {
          expect(rule.message.isNotEmpty, isTrue,
              reason: 'Rule ${rule.ruleName} should have a non-empty message');
          expect(rule.description.isNotEmpty, isTrue,
              reason: 'Rule ${rule.ruleName} should have a non-empty description');
        }
      });

      test('Core rules collection should contain expected rules', () {
        final coreRules = FlutterQualityLints.coreRules;
        expect(coreRules.length, equals(5));
        
        final coreRuleNames = coreRules.map((rule) => rule.ruleName).toSet();
        expect(coreRuleNames, contains('avoid_late_keyword'));
        expect(coreRuleNames, contains('prefer_const_widgets'));
        expect(coreRuleNames, contains('avoid_hardcoded_strings'));
        expect(coreRuleNames, contains('maximum_lines_per_file'));
        expect(coreRuleNames, contains('prefer_named_parameters'));
      });

      test('Non-core rules collection should contain expected rules', () {
        final performanceRules = FlutterQualityLints.performanceRules;
        final architectureRules = FlutterQualityLints.architectureRules;
        final securityRules = FlutterQualityLints.securityRules;
        final totalNonCoreRules = performanceRules.length + architectureRules.length + securityRules.length;
        expect(totalNonCoreRules, equals(6));
        
        final allNonCoreRules = [...performanceRules, ...architectureRules, ...securityRules];
        final nonCoreRuleNames = allNonCoreRules.map((rule) => rule.ruleName).toSet();
        expect(nonCoreRuleNames, contains('prefer_slivers_over_columns'));
        expect(nonCoreRuleNames, contains('avoid_widget_rebuilds'));
        expect(nonCoreRuleNames, contains('prefer_stateless_widgets'));
        expect(nonCoreRuleNames, contains('avoid_build_context_across_async'));
        expect(nonCoreRuleNames, contains('enforce_layer_dependencies'));
        expect(nonCoreRuleNames, contains('avoid_hardcoded_secrets'));
      });

      test('All rules collection should contain core, performance, architecture, and security rules', () {
        final allRules = FlutterQualityLints.allRules;
        final coreRules = FlutterQualityLints.coreRules;
        final performanceRules = FlutterQualityLints.performanceRules;
        final architectureRules = FlutterQualityLints.architectureRules;
        final securityRules = FlutterQualityLints.securityRules;
        
        expect(allRules.length, equals(coreRules.length + performanceRules.length + architectureRules.length + securityRules.length));
      });

      test('Recommended rules collection should be a subset of all rules', () {
        final recommendedRules = FlutterQualityLints.recommendedRules;
        final allRules = FlutterQualityLints.allRules;
        final allRuleNames = allRules.map((rule) => rule.ruleName).toSet();
        
        for (final rule in recommendedRules) {
          expect(allRuleNames, contains(rule.ruleName),
              reason: 'Recommended rule ${rule.ruleName} should be in allRules');
        }
      });

      test('Performance rules collection should contain expected rules', () {
        final performanceRules = FlutterQualityLints.performanceRules;
        expect(performanceRules.length, equals(4));
        
        // Check for specific performance rules
        expect(performanceRules.any((rule) => rule.ruleName == 'prefer_slivers_over_columns'), isTrue);
        expect(performanceRules.any((rule) => rule.ruleName == 'avoid_widget_rebuilds'), isTrue);
        expect(performanceRules.any((rule) => rule.ruleName == 'prefer_stateless_widgets'), isTrue);
        expect(performanceRules.any((rule) => rule.ruleName == 'avoid_build_context_across_async'), isTrue);
      });

      test('Architecture rules collection should contain expected rules', () {
        final architectureRules = FlutterQualityLints.architectureRules;
        expect(architectureRules.length, equals(1));
        expect(architectureRules.any((rule) => rule.ruleName == 'enforce_layer_dependencies'), isTrue);
      });

      test('Security rules collection should contain expected rules', () {
        final securityRules = FlutterQualityLints.securityRules;
        expect(securityRules.length, equals(1));
        expect(securityRules.any((rule) => rule.ruleName == 'avoid_hardcoded_secrets'), isTrue);
      });
    });
  });
}
