import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that suggests using StatelessWidget when possible
class PreferStatelessWidgets extends LintRule {
  const PreferStatelessWidgets();

  @override
  String get ruleName => 'prefer_stateless_widgets';

  @override
  String get message => 'Consider using StatelessWidget instead of StatefulWidget when no mutable state is needed.';

  @override
  String get description => 'Suggests using StatelessWidget for better performance when the widget does not need to maintain mutable state.';

  @override
  bool shouldReport(AstNode node) {
    if (node is ClassDeclaration) {
      return _isUnnecessaryStatefulWidget(node);
    }
    return false;
  }

  bool _isUnnecessaryStatefulWidget(ClassDeclaration classDecl) {
    // Check if class extends StatefulWidget
    if (!_extendsStatefulWidget(classDecl)) {
      return false;
    }
    
    // Find the corresponding State class
    final stateClass = _findStateClass(classDecl);
    if (stateClass == null) {
      return false;
    }
    
    // Analyze if the State class actually uses mutable state
    return !_usesMutableState(stateClass);
  }

  bool _extendsStatefulWidget(ClassDeclaration classDecl) {
    final extendsClause = classDecl.extendsClause;
    if (extendsClause != null) {
      return extendsClause.superclass.name2.toString() == 'StatefulWidget';
    }
    return false;
  }

  ClassDeclaration? _findStateClass(ClassDeclaration widgetClass) {
    // Look for State class in the same compilation unit
    final compilationUnit = _getCompilationUnit(widgetClass);
    if (compilationUnit == null) return null;
    
    final widgetName = widgetClass.name.lexeme;
    final expectedStateName = '${widgetName}State';
    final alternativeStateName = '_${widgetName}State';
    
    for (final declaration in compilationUnit.declarations) {
      if (declaration is ClassDeclaration) {
        final className = declaration.name.lexeme;
        if (className == expectedStateName || className == alternativeStateName) {
          return declaration;
        }
      }
    }
    
    return null;
  }

  bool _usesMutableState(ClassDeclaration stateClass) {
    // Check for state indicators
    for (final member in stateClass.members) {
      // Check for setState calls
      if (_containsSetStateCall(member)) {
        return true;
      }
      
      // Check for mutable instance variables
      if (_hasMutableInstanceVariables(member)) {
        return true;
      }
      
      // Check for lifecycle methods that suggest state management
      if (_hasStateLifecycleMethods(member)) {
        return true;
      }
      
      // Check for controllers or animation controllers
      if (_hasControllers(member)) {
        return true;
      }
    }
    
    return false;
  }

  bool _containsSetStateCall(ClassMember member) {
    if (member is MethodDeclaration) {
      final body = member.body;
      return _searchForMethodCall(body, 'setState');
    }
    return false;
  }

  bool _hasMutableInstanceVariables(ClassMember member) {
    if (member is FieldDeclaration) {
      final fields = member.fields;
      
      // Check if field is not final and not const
      if (!fields.isFinal && !fields.isConst) {
        // Check if it's not just a controller declaration
        for (final variable in fields.variables) {
          final initializer = variable.initializer;
          if (initializer == null) {
            return true; // Uninitialized mutable field
          }
        }
      }
    }
    return false;
  }

  bool _hasStateLifecycleMethods(ClassMember member) {
    if (member is MethodDeclaration) {
      const lifecycleMethods = {
        'initState', 'dispose', 'didUpdateWidget', 
        'didChangeDependencies', 'deactivate'
      };
      
      return lifecycleMethods.contains(member.name.lexeme);
    }
    return false;
  }

  bool _hasControllers(ClassMember member) {
    if (member is FieldDeclaration) {
      final fieldType = member.fields.type?.toString() ?? '';
      
      const controllerTypes = {
        'AnimationController', 'TextEditingController',
        'ScrollController', 'PageController', 'TabController'
      };
      
      return controllerTypes.any((type) => fieldType.contains(type));
    }
    return false;
  }

  bool _searchForMethodCall(FunctionBody? body, String methodName) {
    if (body is BlockFunctionBody) {
      for (final statement in body.block.statements) {
        if (_statementContainsMethodCall(statement, methodName)) {
          return true;
        }
      }
    } else if (body is ExpressionFunctionBody) {
      return _expressionContainsMethodCall(body.expression, methodName);
    }
    return false;
  }

  bool _statementContainsMethodCall(Statement statement, String methodName) {
    if (statement is ExpressionStatement) {
      return _expressionContainsMethodCall(statement.expression, methodName);
    }
    // Could add more statement types as needed
    return false;
  }

  bool _expressionContainsMethodCall(Expression expression, String methodName) {
    if (expression is MethodInvocation) {
      return expression.methodName.name == methodName;
    }
    // Could add recursive checking for nested expressions
    return false;
  }

  CompilationUnit? _getCompilationUnit(AstNode node) {
    AstNode? current = node;
    while (current != null) {
      if (current is CompilationUnit) {
        return current;
      }
      current = current.parent;
    }
    return null;
  }
} 