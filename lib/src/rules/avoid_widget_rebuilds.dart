import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that detects widgets that rebuild unnecessarily
class AvoidWidgetRebuilds extends LintRule {
  const AvoidWidgetRebuilds();

  @override
  String get ruleName => 'avoid_widget_rebuilds';

  @override
  String get message => 'Avoid unnecessary widget rebuilds by using const constructors or extracting widgets.';

  @override
  String get description => 'Detects patterns that cause unnecessary widget rebuilds, such as creating widgets in build methods or using non-const values.';

  @override
  bool shouldReport(AstNode node) {
    if (node is MethodDeclaration && node.name.lexeme == 'build') {
      return _hasRebuildIssues(node);
    }
    return false;
  }

  bool _hasRebuildIssues(MethodDeclaration buildMethod) {
    final body = buildMethod.body;
    if (body is BlockFunctionBody) {
      final statements = body.block.statements;
      
      for (final statement in statements) {
        if (_containsRebuildCauses(statement)) {
          return true;
        }
      }
    } else if (body is ExpressionFunctionBody) {
      return _containsRebuildCauses(body.expression);
    }
    
    return false;
  }

  bool _containsRebuildCauses(AstNode node) {
    if (node is InstanceCreationExpression) {
      // Check for non-const widget creation
      if (_isWidgetCreation(node) && !node.isConst) {
        return _hasComplexArguments(node);
      }
    }
    
    if (node is MethodInvocation) {
      // Check for method calls that create widgets inline
      if (_createsWidgetsInline(node)) {
        return true;
      }
    }
    
    if (node is FunctionExpression) {
      // Check for inline function expressions that create widgets
      return _createsFunctionInline(node);
    }
    
    // Check specific child nodes that we care about
    if (node is Block) {
      for (final statement in node.statements) {
        if (_containsRebuildCauses(statement)) {
          return true;
        }
      }
    }
    
    if (node is ExpressionStatement) {
      return _containsRebuildCauses(node.expression);
    }
    
    if (node is ReturnStatement && node.expression != null) {
      return _containsRebuildCauses(node.expression!);
    }
    
    return false;
  }

  bool _isWidgetCreation(InstanceCreationExpression node) {
    final constructorName = node.constructorName.type.name2.toString();
    
    // Common Flutter widgets that should often be const
    const commonWidgets = {
      'Text', 'Icon', 'Container', 'SizedBox', 'Padding',
      'Center', 'Column', 'Row', 'Stack', 'Positioned',
      'Expanded', 'Flexible', 'Spacer', 'Divider'
    };
    
    return commonWidgets.contains(constructorName);
  }

  bool _hasComplexArguments(InstanceCreationExpression node) {
    final arguments = node.argumentList.arguments;
    
    for (final arg in arguments) {
      if (arg is NamedExpression) {
        // Check for complex expressions that prevent const
        if (_isComplexExpression(arg.expression)) {
          return true;
        }
      } else if (_isComplexExpression(arg)) {
        return true;
      }
    }
    
    return false;
  }

  bool _isComplexExpression(Expression expr) {
    // Complex expressions that prevent const usage
    if (expr is MethodInvocation || 
        expr is PropertyAccess ||
        expr is PrefixedIdentifier ||
        expr is ConditionalExpression ||
        expr is BinaryExpression) {
      return true;
    }
    
    if (expr is InstanceCreationExpression && !expr.isConst) {
      return true;
    }
    
    return false;
  }

  bool _createsWidgetsInline(MethodInvocation node) {
    final methodName = node.methodName.name;
    
    // Methods that often create widgets inline
    const widgetCreationMethods = {
      'map', 'generate', 'builder', 'separated'
    };
    
    return widgetCreationMethods.contains(methodName);
  }

  bool _createsFunctionInline(FunctionExpression node) {
    // Check if function expression creates widgets
    final body = node.body;
    if (body is ExpressionFunctionBody) {
      return body.expression is InstanceCreationExpression;
    } else if (body is BlockFunctionBody) {
      final statements = body.block.statements;
      return statements.any((stmt) => 
        stmt is ReturnStatement && 
        stmt.expression is InstanceCreationExpression
      );
    }
    
    return false;
  }
} 