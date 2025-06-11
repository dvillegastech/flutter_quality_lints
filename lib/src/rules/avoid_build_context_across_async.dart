import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that prevents using BuildContext across async operations
class AvoidBuildContextAcrossAsync extends LintRule {
  const AvoidBuildContextAcrossAsync();

  @override
  String get ruleName => 'avoid_build_context_across_async';

  @override
  String get message => 'Avoid using BuildContext across async operations. Check if widget is still mounted.';

  @override
  String get description => 'Prevents using BuildContext after await calls without checking if the widget is still mounted, which can cause errors.';

  @override
  bool shouldReport(AstNode node) {
    if (node is MethodDeclaration && node.body != null) {
      return _hasUnsafeContextUsage(node.body!);
    }
    return false;
  }

  bool _hasUnsafeContextUsage(FunctionBody body) {
    if (body is BlockFunctionBody) {
      return _analyzeStatements(body.block.statements);
    } else if (body is ExpressionFunctionBody && body.functionDefinition.lexeme == '=>') {
      // Expression function bodies are typically synchronous
      return false;
    }
    return false;
  }

  bool _analyzeStatements(List<Statement> statements) {
    bool hasAwaitCall = false;
    
    for (int i = 0; i < statements.length; i++) {
      final statement = statements[i];
      
      // Check if this statement contains an await
      if (_containsAwaitExpression(statement)) {
        hasAwaitCall = true;
        continue;
      }
      
      // If we've seen an await and this statement uses context unsafely
      if (hasAwaitCall && _usesContextUnsafely(statement)) {
        return true;
      }
    }
    
    return false;
  }

  bool _containsAwaitExpression(Statement statement) {
    if (statement is ExpressionStatement) {
      return _expressionContainsAwait(statement.expression);
    } else if (statement is VariableDeclarationStatement) {
      for (final variable in statement.variables.variables) {
        if (variable.initializer != null && 
            _expressionContainsAwait(variable.initializer!)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _expressionContainsAwait(Expression expression) {
    if (expression is AwaitExpression) {
      return true;
    }
    
    if (expression is AssignmentExpression) {
      return _expressionContainsAwait(expression.rightHandSide);
    }
    
    if (expression is MethodInvocation) {
      // Check arguments for await expressions
      for (final arg in expression.argumentList.arguments) {
        if (arg is Expression && _expressionContainsAwait(arg)) {
          return true;
        }
      }
    }
    
    return false;
  }

  bool _usesContextUnsafely(Statement statement) {
    if (statement is ExpressionStatement) {
      return _expressionUsesContext(statement.expression);
    }
    return false;
  }

  bool _expressionUsesContext(Expression expression) {
    // Check for direct context usage
    if (expression is SimpleIdentifier && expression.name == 'context') {
      return true;
    }
    
    // Check for context property access
    if (expression is PropertyAccess) {
      if (expression.target is SimpleIdentifier && 
          (expression.target as SimpleIdentifier).name == 'context') {
        return true;
      }
    }
    
    // Check for method calls that use context
    if (expression is MethodInvocation) {
      // Check if the target is context
      if (expression.target is SimpleIdentifier && 
          (expression.target as SimpleIdentifier).name == 'context') {
        return true;
      }
      
      // Check for Navigator.of(context), Theme.of(context), etc.
      if (expression.target is SimpleIdentifier) {
        final targetName = (expression.target as SimpleIdentifier).name;
        const contextConsumers = {
          'Navigator', 'Theme', 'MediaQuery', 'Scaffold', 
          'ModalRoute', 'DefaultTabController'
        };
        
        if (contextConsumers.contains(targetName) && 
            expression.methodName.name == 'of' &&
            _argumentListContainsContext(expression.argumentList)) {
          return true;
        }
      }
      
      // Check for showDialog, showBottomSheet, etc.
      if (expression.target == null) {
        const contextMethods = {
          'showDialog', 'showBottomSheet', 'showModalBottomSheet',
          'showDatePicker', 'showTimePicker', 'showSearch'
        };
        
        if (contextMethods.contains(expression.methodName.name) &&
            _argumentListContainsContext(expression.argumentList)) {
          return true;
        }
      }
    }
    
    return false;
  }

  bool _argumentListContainsContext(ArgumentList argumentList) {
    for (final arg in argumentList.arguments) {
      if (arg is SimpleIdentifier && arg.name == 'context') {
        return true;
      }
      if (arg is NamedExpression && 
          arg.expression is SimpleIdentifier &&
          (arg.expression as SimpleIdentifier).name == 'context') {
        return true;
      }
    }
    return false;
  }
} 