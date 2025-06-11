import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that suggests using Slivers instead of Column for long lists
class PreferSliversOverColumns extends LintRule {
  const PreferSliversOverColumns();

  @override
  String get ruleName => 'prefer_slivers_over_columns';

  @override
  String get message => 'Consider using Slivers instead of Column for better performance with long lists.';

  @override
  String get description => 'Suggests using SliverList or CustomScrollView instead of Column when dealing with potentially long lists to improve scrolling performance.';

  @override
  bool shouldReport(AstNode node) {
    if (node is InstanceCreationExpression) {
      final constructorName = node.constructorName.type.name2.toString();
      
      if (constructorName == 'Column') {
        return _hasPerformanceRisk(node);
      }
    }
    return false;
  }

  bool _hasPerformanceRisk(InstanceCreationExpression columnNode) {
    // Check if Column has many children or contains ListView.builder patterns
    final arguments = columnNode.argumentList.arguments;
    
    for (final arg in arguments) {
      if (arg is NamedExpression && arg.name.label.name == 'children') {
        if (arg.expression is ListLiteral) {
          final listLiteral = arg.expression as ListLiteral;
          
          // Risk factors:
          // 1. More than 10 direct children
          if (listLiteral.elements.length > 10) {
            return true;
          }
          
          // 2. Contains ListView or GridView (nested scrollables)
          for (final element in listLiteral.elements) {
            if (_containsScrollableWidget(element)) {
              return true;
            }
          }
          
          // 3. Contains loops or map operations that could generate many widgets
          if (_containsIterativeWidgetGeneration(listLiteral)) {
            return true;
          }
        }
      }
    }
    
    return false;
  }

  bool _containsScrollableWidget(CollectionElement element) {
    if (element is Expression && element is InstanceCreationExpression) {
      final constructorName = element.constructorName.type.name2.toString();
      const scrollableWidgets = {
        'ListView', 'GridView', 'PageView', 'CustomScrollView'
      };
      return scrollableWidgets.contains(constructorName);
    }
    return false;
  }

  bool _containsIterativeWidgetGeneration(ListLiteral listLiteral) {
    // Look for spread operators or method calls that suggest dynamic generation
    for (final element in listLiteral.elements) {
      if (element is SpreadElement) {
        return true;
      }
      
      // Look for .map(), .generate(), etc. patterns
      if (element is Expression && element is MethodInvocation) {
        final methodName = element.methodName.name;
        if (methodName == 'map' || methodName == 'generate' || methodName == 'builder') {
          return true;
        }
      }
    }
    return false;
  }
} 