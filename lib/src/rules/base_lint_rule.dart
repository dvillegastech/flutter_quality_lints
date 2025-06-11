import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Base class for all custom linting rules
abstract class LintRule extends DartLintRule {
  /// Creates a new instance of [LintRule]
  const LintRule() : super(code: const LintCode(name: '', problemMessage: ''));

  /// The unique code for this lint rule
  String get ruleName;

  @override
  LintCode get code => LintCode(
    name: ruleName,
    problemMessage: message,
    errorSeverity: severity,
  );

  /// The severity level of this lint rule
  ErrorSeverity get severity => ErrorSeverity.WARNING;

  /// The message to display when this rule is violated
  String get message;

  /// The description of what this rule checks for
  String get description;

  /// Checks if the given node should be reported as a violation
  bool shouldReport(AstNode node);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final visitor = _LintRuleVisitor(this, reporter);
      node.accept(visitor);
    });
  }
}

class _LintRuleVisitor extends RecursiveAstVisitor<void> {
  final LintRule rule;
  final ErrorReporter reporter;

  _LintRuleVisitor(this.rule, this.reporter);

  void visitNode(AstNode node) {
    if (rule.shouldReport(node)) {
      reporter.reportErrorForNode(
        rule.code,
        node,
      );
    }
    node.visitChildren(this);
  }
} 