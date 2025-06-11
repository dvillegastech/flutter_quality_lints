import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that encourages the use of trailing commas in function calls and literals
class PreferTrailingCommas extends LintRule {
  const PreferTrailingCommas();

  @override
  String get ruleName => 'prefer_trailing_commas';

  @override
  String get message => 'Consider adding a trailing comma to improve formatting and version control diffs.';

  @override
  String get description => 'Encourages the use of trailing commas in argument lists, parameters, and collection literals.';

  @override
  bool shouldReport(AstNode node) {
    if (node is ArgumentList && _shouldHaveTrailingComma(node.arguments)) {
      return !_hasTrailingComma(node.arguments, node.rightParenthesis.offset);
    }
    
    if (node is FormalParameterList && _shouldHaveTrailingComma(node.parameters)) {
      return !_hasTrailingComma(node.parameters, node.rightParenthesis.offset);
    }
    
    if (node is ListLiteral && _shouldHaveTrailingComma(node.elements)) {
      return !_hasTrailingComma(node.elements, node.rightBracket.offset);
    }
    
    if (node is SetOrMapLiteral && _shouldHaveTrailingComma(node.elements)) {
      return !_hasTrailingComma(node.elements, node.rightBracket.offset);
    }
    
    return false;
  }

  bool _shouldHaveTrailingComma(List<AstNode> elements) {
    if (elements.isEmpty) return false;
    
    // Only suggest trailing comma for multiline lists with 2+ elements
    if (elements.length < 2) return false;
    
    // Check if it's multiline by comparing line numbers
    final compilationUnit = _getCompilationUnit(elements.first);
    if (compilationUnit?.lineInfo == null) return false;
    
    final lineInfo = compilationUnit!.lineInfo;
    final firstLine = lineInfo.getLocation(elements.first.offset).lineNumber;
    final lastLine = lineInfo.getLocation(elements.last.end).lineNumber;
    
    return lastLine > firstLine;
  }

  bool _hasTrailingComma(List<AstNode> elements, int endOffset) {
    if (elements.isEmpty) return false;
    
    final lastElement = elements.last;
    final textBetween = lastElement.end < endOffset;
    
    // This is a simplified check - in practice, you'd need to parse the source text
    // to check for the comma character between the last element and the closing bracket
    return textBetween; // Placeholder - would need source text analysis
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