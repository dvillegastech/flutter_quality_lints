import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that encourages the use of named parameters in functions and constructors
class PreferNamedParameters extends LintRule {
  const PreferNamedParameters();

  @override
  String get ruleName => 'prefer_named_parameters';

  @override
  String get message => 'Prefer using named parameters in functions and constructors.';

  @override
  String get description => 'Encourages the use of named parameters for better readability and maintainability.';

  @override
  bool shouldReport(AstNode node) {
    if (node is FunctionDeclaration) {
       final formalParameterList = node.functionExpression.parameters;
       if (formalParameterList?.parameters.isNotEmpty ?? false) {
           // If there is at least one positional (non-named) parameter, report it.
           return formalParameterList!.parameters.any((p) => p.isPositional);
       }
    } else if (node is ConstructorDeclaration) {
       final formalParameterList = node.parameters;
       if (formalParameterList.parameters.isNotEmpty) {
           // If there is at least one positional (non-named) parameter, report it.
           return formalParameterList.parameters.any((p) => p.isPositional);
       }
    }
    return false;
  }
} 