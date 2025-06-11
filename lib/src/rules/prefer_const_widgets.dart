import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that encourages the use of const widgets where possible
class PreferConstWidgets extends LintRule {
  const PreferConstWidgets();

  @override
  String get ruleName => 'prefer_const_widgets';

  @override
  String get message => 'Prefer using const constructors for widgets when possible.';

  @override
  String get description => 'Encourages the use of const constructors for widgets to improve performance.';

  @override
  bool shouldReport(AstNode node) {
    if (node is InstanceCreationExpression) {
      final constructorName = node.constructorName.type.name2.toString();
      // You can expand this list with more widgets as needed
      const widgetNames = ['Text', 'Container', 'SizedBox', 'Padding', 'Center'];
      if (widgetNames.contains(constructorName) && !node.isConst) {
         // Exclude instanciaciones que no sean const (por ejemplo, si se pasan variables o funciones)
         return true;
      }
    }
    return false;
  }
} 