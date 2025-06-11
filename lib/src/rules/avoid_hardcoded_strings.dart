import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages the use of hardcoded strings in widgets
class AvoidHardcodedStrings extends LintRule {
  const AvoidHardcodedStrings();

  @override
  String get ruleName => 'avoid_hardcoded_strings';

  @override
  String get message => 'Avoid using hardcoded strings in widgets. Use localization instead.';

  @override
  String get description => 'Discourages the use of hardcoded strings in widgets to promote localization.';

  @override
  bool shouldReport(AstNode node) {
    // Detects string literals used as arguments in widget constructors (e.g., Text('Hello'))
    if (node is StringLiteral && node.parent is ArgumentList) {
      final argumentList = node.parent as ArgumentList;
      final parent = argumentList.parent;
      if (parent is InstanceCreationExpression) {
        final constructorName = parent.constructorName.type.name2.toString();
        // You can expand this list with more widgets as needed
        const widgetNames = ['Text', 'AppBar', 'FlatButton', 'ElevatedButton'];
        if (widgetNames.contains(constructorName)) {
          // Exclude empty strings and strings that look like keys
          final value = node.stringValue ?? '';
          if (value.isNotEmpty && !value.startsWith('key_')) {
            return true;
          }
        }
      }
    }
    return false;
  }
} 