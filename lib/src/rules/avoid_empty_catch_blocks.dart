import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages empty catch blocks
class AvoidEmptyCatchBlocks extends LintRule {
  const AvoidEmptyCatchBlocks();

  @override
  String get ruleName => 'avoid_empty_catch_blocks';

  @override
  String get message => 'Avoid empty catch blocks. Consider logging the error or rethrowing it.';

  @override
  String get description => 'Discourages empty catch blocks that silently ignore exceptions without proper handling.';

  @override
  bool shouldReport(AstNode node) {
    if (node is CatchClause) {
      final body = node.body;
      return _isEmpty(body);
    }
    return false;
  }

  bool _isEmpty(Block block) {
    if (block.statements.isEmpty) {
      return true;
    }
    
    // Check if all statements are just comments or empty statements
    for (final statement in block.statements) {
      if (statement is! EmptyStatement) {
        // If there's at least one non-empty statement, it's not empty
        return false;
      }
    }
    
    return true;
  }
} 