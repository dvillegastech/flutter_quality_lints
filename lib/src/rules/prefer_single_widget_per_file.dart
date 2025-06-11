import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that encourages having only one widget class per file
class PreferSingleWidgetPerFile extends LintRule {
  const PreferSingleWidgetPerFile();

  @override
  String get ruleName => 'prefer_single_widget_per_file';

  @override
  String get message => 'Prefer having only one widget class per file for better organization.';

  @override
  String get description => 'Encourages organizing code by having a single widget class per file to improve maintainability.';

  @override
  bool shouldReport(AstNode node) {
    if (node is CompilationUnit) {
      final widgetClasses = <ClassDeclaration>[];
      
      for (final declaration in node.declarations) {
        if (declaration is ClassDeclaration && _isWidgetClass(declaration)) {
          widgetClasses.add(declaration);
        }
      }
      
      return widgetClasses.length > 1;
    }
    return false;
  }

  bool _isWidgetClass(ClassDeclaration classDeclaration) {
    final extendsClause = classDeclaration.extendsClause;
    if (extendsClause != null) {
      final superclass = extendsClause.superclass.name2.toString();
      return _isFlutterWidget(superclass);
    }
    
    final implementsClause = classDeclaration.implementsClause;
    if (implementsClause != null) {
      for (final interface in implementsClause.interfaces) {
        if (_isFlutterWidget(interface.name2.toString())) {
          return true;
        }
      }
    }
    
    return false;
  }

  bool _isFlutterWidget(String className) {
    const widgetTypes = {
      'StatelessWidget',
      'StatefulWidget',
      'InheritedWidget',
      'RenderObjectWidget',
      'ProxyWidget',
      'Widget',
    };
    
    return widgetTypes.contains(className);
  }
} 