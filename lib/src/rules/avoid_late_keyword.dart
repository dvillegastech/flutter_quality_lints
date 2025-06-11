import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages the use of the `late` keyword
class AvoidLateKeyword extends LintRule {
  /// Creates a new instance of [AvoidLateKeyword]
  const AvoidLateKeyword();

  @override
  String get ruleName => 'avoid_late_keyword';

  @override
  String get message => 'Avoid using the late keyword. Consider using nullable types or initializing variables directly.';

  @override
  String get description => 'Discourages the use of the late keyword as it can lead to runtime errors.';

  @override
  bool shouldReport(AstNode node) {
    if (node is VariableDeclarationList) {
      return node.lateKeyword != null;
    }
    return false;
  }
} 