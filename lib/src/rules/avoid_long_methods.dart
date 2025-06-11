import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that discourages overly long methods and functions
class AvoidLongMethods extends LintRule {
  const AvoidLongMethods();

  @override
  String get ruleName => 'avoid_long_methods';

  @override
  String get message => 'Method or function is too long. Consider breaking it into smaller, more focused methods.';

  @override
  String get description => 'Discourages methods and functions that exceed a reasonable length to improve readability and maintainability.';

  static const int _maxLines = 50;

  @override
  bool shouldReport(AstNode node) {
    if (node is FunctionDeclaration || node is MethodDeclaration) {
      return _getMethodLength(node) > _maxLines;
    }
    return false;
  }

  int _getMethodLength(AstNode node) {
    int startLine = 0;
    int endLine = 0;

    if (node is FunctionDeclaration) {
      startLine = node.offset;
      endLine = node.end;
    } else if (node is MethodDeclaration) {
      startLine = node.offset;
      endLine = node.end;
    }

    // Convert offset to line numbers using lineInfo if available
    final compilationUnit = _getCompilationUnit(node);
    if (compilationUnit?.lineInfo != null) {
      final lineInfo = compilationUnit!.lineInfo;
      final startLineNumber = lineInfo.getLocation(startLine).lineNumber;
      final endLineNumber = lineInfo.getLocation(endLine).lineNumber;
      return endLineNumber - startLineNumber + 1;
    }

    // Fallback: estimate based on character count (rough approximation)
    return (endLine - startLine) ~/ 80; // Assuming ~80 chars per line
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