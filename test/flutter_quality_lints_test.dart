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

      test('Advanced rules collection should contain expected rules', () {
        final advancedRules = FlutterQualityLints.advancedRules;
        expect(advancedRules.length, equals(7));
        
        final advancedRuleNames = advancedRules.map((rule) => rule.ruleName).toSet();
        expect(advancedRuleNames, contains('avoid_nested_conditionals'));
        expect(advancedRuleNames, contains('prefer_early_return'));
        expect(advancedRuleNames, contains('avoid_magic_numbers'));
        expect(advancedRuleNames, contains('prefer_single_widget_per_file'));
        expect(advancedRuleNames, contains('avoid_long_methods'));
        expect(advancedRuleNames, contains('prefer_trailing_commas'));
        expect(advancedRuleNames, contains('avoid_empty_catch_blocks'));
      });

      test('All rules collection should contain both core and advanced rules', () {
        final allRules = FlutterQualityLints.allRules;
        final coreRules = FlutterQualityLints.coreRules;
        final advancedRules = FlutterQualityLints.advancedRules;
        
        expect(allRules.length, equals(coreRules.length + advancedRules.length));
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
    });
  });
}
