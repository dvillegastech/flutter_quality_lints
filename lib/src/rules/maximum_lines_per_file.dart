import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that enforces a maximum number of lines per file
class MaximumLinesPerFile extends LintRule {
  const MaximumLinesPerFile();

  @override
  String get ruleName => 'maximum_lines_per_file';

  @override
  String get message => 'File exceeds the maximum allowed number of lines.';

  @override
  String get description => 'Enforces a maximum number of lines per file to improve readability and maintainability.';

  @override
  bool shouldReport(AstNode node) {
    if (node is CompilationUnit) {
       // Assume a maximum of 300 lines (adjustable as needed)
       const int maxLines = 300;
       final int lineCount = node.lineInfo.lineCount;
       return lineCount > maxLines;
    }
    return false;
  }
} 