import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages the use of magic numbers
class AvoidMagicNumbers extends LintRule {
  const AvoidMagicNumbers();

  @override
  String get ruleName => 'avoid_magic_numbers';

  @override
  String get message => 'Avoid using magic numbers. Consider defining them as named constants.';

  @override
  String get description => 'Discourages the use of numeric literals without explanation to improve code readability.';

  static const _allowedNumbers = {0, 1, -1, 2, 10, 100, 1000};

  @override
  bool shouldReport(AstNode node) {
    if (node is IntegerLiteral) {
      final value = node.value;
      if (value != null && !_allowedNumbers.contains(value)) {
        // Don't report if it's in a const context or variable declaration
        return !_isInConstContext(node) && !_isInVariableDeclaration(node);
      }
    } else if (node is DoubleLiteral) {
      final value = node.value;
      // Allow common decimal values like 0.0, 1.0, 0.5, etc.
      if (value != 0.0 && value != 1.0 && value != 0.5 && value != 2.0) {
        return !_isInConstContext(node) && !_isInVariableDeclaration(node);
      }
    }
    return false;
  }

  bool _isInConstContext(AstNode node) {
    AstNode? parent = node.parent;
    while (parent != null) {
      if (parent is InstanceCreationExpression && parent.keyword?.keyword.toString() == 'const') {
        return true;
      }
      if (parent is VariableDeclaration && parent.parent is VariableDeclarationList) {
        final list = parent.parent as VariableDeclarationList;
        return list.keyword?.keyword.toString() == 'const';
      }
      parent = parent.parent;
    }
    return false;
  }

  bool _isInVariableDeclaration(AstNode node) {
    AstNode? parent = node.parent;
    while (parent != null) {
      if (parent is VariableDeclaration) {
        return true;
      }
      parent = parent.parent;
    }
    return false;
  }
} 