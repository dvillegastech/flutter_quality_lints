import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that encourages using early returns instead of nested conditions
class PreferEarlyReturn extends LintRule {
  const PreferEarlyReturn();

  @override
  String get ruleName => 'prefer_early_return';

  @override
  String get message => 'Consider using early return to reduce nesting and improve readability.';

  @override
  String get description => 'Encourages the use of early returns to avoid unnecessary nesting in functions.';

  @override
  bool shouldReport(AstNode node) {
    if (node is FunctionDeclaration || node is MethodDeclaration) {
      return _hasUnnecessaryNesting(node);
    }
    return false;
  }

  bool _hasUnnecessaryNesting(AstNode functionNode) {
    BlockFunctionBody? body;
    
    if (functionNode is FunctionDeclaration) {
      body = functionNode.functionExpression.body as BlockFunctionBody?;
    } else if (functionNode is MethodDeclaration) {
      body = functionNode.body as BlockFunctionBody?;
    }
    
    if (body == null || body.block.statements.length != 1) {
      return false;
    }
    
    final statement = body.block.statements.first;
    if (statement is IfStatement && statement.elseStatement == null) {
      // Check if the if statement contains the entire function logic
      if (statement.thenStatement is Block) {
        final block = statement.thenStatement as Block;
        return block.statements.length > 2; // More than just a simple operation
      }
    }
    
    return false;
  }
} 