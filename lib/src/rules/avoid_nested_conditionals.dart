import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages deeply nested conditional statements
class AvoidNestedConditionals extends LintRule {
  const AvoidNestedConditionals();

  @override
  String get ruleName => 'avoid_nested_conditionals';

  @override
  String get message => 'Avoid deeply nested conditional statements. Consider using early returns or extracting methods.';

  @override
  String get description => 'Discourages deeply nested if statements and conditional expressions to improve code readability.';

  @override
  bool shouldReport(AstNode node) {
    if (node is IfStatement) {
      return _getNestedLevel(node) > 3;
    }
    return false;
  }

  int _getNestedLevel(IfStatement ifStatement, [int level = 1]) {
    int maxLevel = level;
    
    // Check then statement
    if (ifStatement.thenStatement is IfStatement) {
      final thenLevel = _getNestedLevel(ifStatement.thenStatement as IfStatement, level + 1);
      if (thenLevel > maxLevel) maxLevel = thenLevel;
    }
    
    // Check else statement
    if (ifStatement.elseStatement is IfStatement) {
      final elseLevel = _getNestedLevel(ifStatement.elseStatement as IfStatement, level + 1);
      if (elseLevel > maxLevel) maxLevel = elseLevel;
    }
    
    return maxLevel;
  }
} 