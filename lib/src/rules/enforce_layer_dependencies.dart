import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that enforces proper layer dependencies in clean architecture
class EnforceLayerDependencies extends LintRule {
  const EnforceLayerDependencies();

  @override
  String get ruleName => 'enforce_layer_dependencies';

  @override
  String get message => 'Layer dependency violation detected. Check clean architecture rules.';

  @override
  String get description => 'Enforces proper layer dependencies in clean architecture: UI -> Domain <- Data, preventing circular dependencies.';

  @override
  bool shouldReport(AstNode node) {
    if (node is ImportDirective) {
      return _violatesLayerDependencies(node);
    }
    return false;
  }

  bool _violatesLayerDependencies(ImportDirective importDirective) {
    final importPath = importDirective.uri.stringValue;
    if (importPath == null) return false;
    
    // Get the current file's layer from compilation unit
    final compilationUnit = _getCompilationUnit(importDirective);
    if (compilationUnit == null) return false;
    
    final currentFilePath = _getCurrentFilePath(compilationUnit);
    final currentLayer = _getLayerFromPath(currentFilePath);
    if (currentLayer == null) return false;
    
    // Get the imported file's layer
    final importedLayer = _getLayerFromPath(importPath);
    if (importedLayer == null) return false;
    
    // Check if this import violates layer dependencies
    return _isViolation(currentLayer, importedLayer);
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

  String _getCurrentFilePath(CompilationUnit compilationUnit) {
    // Try to get file path from the compilation unit
    // This is a simplified approach - in a real implementation,
    // you might need to access the analysis session or resolver
    return compilationUnit.toString();
  }

  LayerType? _getLayerFromPath(String path) {
    final lowerPath = path.toLowerCase();
    
    // UI/Presentation Layer
    if (lowerPath.contains('/presentation/') || 
        lowerPath.contains('/ui/') ||
        lowerPath.contains('/pages/') ||
        lowerPath.contains('/screens/') ||
        lowerPath.contains('/widgets/')) {
      return LayerType.presentation;
    }
    
    // Domain Layer
    if (lowerPath.contains('/domain/') ||
        lowerPath.contains('/entities/') ||
        lowerPath.contains('/usecases/') ||
        lowerPath.contains('/repositories/')) {
      return LayerType.domain;
    }
    
    // Data Layer
    if (lowerPath.contains('/data/') ||
        lowerPath.contains('/datasources/') ||
        lowerPath.contains('/models/') ||
        lowerPath.contains('/repositories/') && lowerPath.contains('impl')) {
      return LayerType.data;
    }
    
    // Infrastructure Layer
    if (lowerPath.contains('/infrastructure/') ||
        lowerPath.contains('/external/') ||
        lowerPath.contains('/services/')) {
      return LayerType.infrastructure;
    }
    
    return null;
  }

  bool _isViolation(LayerType currentLayer, LayerType importedLayer) {
    switch (currentLayer) {
      case LayerType.domain:
        // Domain layer should not depend on presentation, data, or infrastructure
        return importedLayer == LayerType.presentation ||
               importedLayer == LayerType.data ||
               importedLayer == LayerType.infrastructure;
               
      case LayerType.presentation:
        // Presentation layer should not depend on data or infrastructure
        return importedLayer == LayerType.data ||
               importedLayer == LayerType.infrastructure;
               
      case LayerType.data:
        // Data layer should not depend on presentation
        return importedLayer == LayerType.presentation;
        
      case LayerType.infrastructure:
        // Infrastructure layer should not depend on presentation
        return importedLayer == LayerType.presentation;
    }
  }
}

enum LayerType {
  presentation,
  domain,
  data,
  infrastructure,
} 