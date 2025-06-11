import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// Auto-fix engine for applying automatic fixes
class AutoFixEngine {
  final List<AutoFix> _availableFixes = [];
  
  AutoFixEngine() {
    _registerFixes();
  }
  
  void _registerFixes() {
    _availableFixes.addAll([
      AddConstToWidgetFix(),
      ConvertToStatelessWidgetFix(),
      AddTrailingCommaFix(),
      RemoveMagicNumberFix(),
      AddMountedCheckFix(),
      SimplifyConditionalFix(),
    ]);
  }
  
  /// Applies all available automatic fixes to a file
  Future<FixResult> fixFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return FixResult(
        success: false,
        message: 'File not found: $filePath',
        fixesApplied: 0,
      );
    }
    
    final content = await file.readAsString();
    final parseResult = parseString(content: content, path: filePath);
    
    if (parseResult.errors.isNotEmpty) {
      return FixResult(
        success: false,
        message: 'Syntax error in file',
        fixesApplied: 0,
      );
    }
    
    String modifiedContent = content;
    int totalFixes = 0;
    
    for (final fix in _availableFixes) {
      final result = fix.apply(modifiedContent, parseResult.unit);
      if (result.wasModified) {
        modifiedContent = result.content;
        totalFixes += result.fixesApplied;
      }
    }
    
    if (totalFixes > 0) {
      await file.writeAsString(modifiedContent);
    }
    
    return FixResult(
      success: true,
      message: 'Fixes applied successfully',
      fixesApplied: totalFixes,
    );
  }
  
  /// Applies fixes to an entire directory
  Future<DirectoryFixResult> fixDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return DirectoryFixResult(
        success: false,
        message: 'Directory not found: $directoryPath',
        filesProcessed: 0,
        totalFixes: 0,
      );
    }
    
    final dartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.contains('.g.dart'))
        .where((file) => !file.path.contains('.freezed.dart'));
    
    int filesProcessed = 0;
    int totalFixes = 0;
    final List<String> processedFiles = [];
    
    for (final file in dartFiles) {
      final result = await fixFile(file.path);
      if (result.success) {
        filesProcessed++;
        totalFixes += result.fixesApplied;
        if (result.fixesApplied > 0) {
          processedFiles.add(file.path);
        }
      }
    }
    
    return DirectoryFixResult(
      success: true,
      message: 'Directory processed successfully',
      filesProcessed: filesProcessed,
      totalFixes: totalFixes,
      modifiedFiles: processedFiles,
    );
  }
  
  /// Lists all available fixes
  List<String> getAvailableFixes() {
    return _availableFixes.map((fix) => fix.name).toList();
  }
}

/// Result of applying fixes to a file
class FixResult {
  final bool success;
  final String message;
  final int fixesApplied;
  
  FixResult({
    required this.success,
    required this.message,
    required this.fixesApplied,
  });
}

/// Result of applying fixes to a directory
class DirectoryFixResult {
  final bool success;
  final String message;
  final int filesProcessed;
  final int totalFixes;
  final List<String> modifiedFiles;
  
  DirectoryFixResult({
    required this.success,
    required this.message,
    required this.filesProcessed,
    required this.totalFixes,
    this.modifiedFiles = const [],
  });
}

/// Result of applying a specific fix
class AutoFixResult {
  final String content;
  final bool wasModified;
  final int fixesApplied;
  
  AutoFixResult({
    required this.content,
    required this.wasModified,
    required this.fixesApplied,
  });
}

/// Base class for all automatic fixes
abstract class AutoFix {
  String get name;
  String get description;
  
  AutoFixResult apply(String content, CompilationUnit unit);
}

/// Fix to add const to widgets
class AddConstToWidgetFix extends AutoFix {
  @override
  String get name => 'add_const_to_widgets';
  
  @override
  String get description => 'Adds const to widget constructors when possible';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    final visitor = _AddConstVisitor();
    unit.accept(visitor);
    
    if (visitor.modifications.isEmpty) {
      return AutoFixResult(
        content: content,
        wasModified: false,
        fixesApplied: 0,
      );
    }
    
    String modifiedContent = content;
    int offset = 0;
    
    for (final mod in visitor.modifications) {
      final position = mod.offset + offset;
      modifiedContent = '${modifiedContent.substring(0, position)}const ${modifiedContent.substring(position)}';
      offset += 6; // length of 'const '
    }
    
    return AutoFixResult(
      content: modifiedContent,
      wasModified: true,
      fixesApplied: visitor.modifications.length,
    );
  }
}

class _AddConstVisitor extends RecursiveAstVisitor<void> {
  final List<_Modification> modifications = [];
  
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.keyword == null && _canBeConst(node)) {
      modifications.add(_Modification(node.offset));
    }
    super.visitInstanceCreationExpression(node);
  }
  
  bool _canBeConst(InstanceCreationExpression node) {
    // Simplified logic - in real implementation, check if all arguments are const
    final typeName = node.constructorName.type.name2.lexeme;
    const widgetTypes = {
      'Text', 'Icon', 'Container', 'Padding', 'Center', 'Column', 'Row',
      'SizedBox', 'Expanded', 'Flexible'
    };
    return widgetTypes.contains(typeName);
  }
}

/// Fix to convert StatefulWidget to StatelessWidget
class ConvertToStatelessWidgetFix extends AutoFix {
  @override
  String get name => 'convert_to_stateless_widget';
  
  @override
  String get description => 'Converts StatefulWidget to StatelessWidget when not using mutable state';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    final visitor = _StatelessConversionVisitor();
    unit.accept(visitor);
    
    if (!visitor.canConvert) {
      return AutoFixResult(
        content: content,
        wasModified: false,
        fixesApplied: 0,
      );
    }
    
    // Simplified conversion logic
    String modifiedContent = content;
    modifiedContent = modifiedContent.replaceAll('StatefulWidget', 'StatelessWidget');
    modifiedContent = modifiedContent.replaceAll('createState()', 'build(BuildContext context)');
    
    return AutoFixResult(
      content: modifiedContent,
      wasModified: true,
      fixesApplied: 1,
    );
  }
}

class _StatelessConversionVisitor extends RecursiveAstVisitor<void> {
  bool canConvert = false;
  bool hasSetState = false;
  bool hasLifecycleMethods = false;
  
  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name == 'setState') {
      hasSetState = true;
    }
    super.visitMethodInvocation(node);
  }
  
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.value();
    if (['initState', 'dispose', 'didUpdateWidget'].contains(name)) {
      hasLifecycleMethods = true;
    }
    super.visitMethodDeclaration(node);
  }
}

/// Fix to add trailing commas
class AddTrailingCommaFix extends AutoFix {
  @override
  String get name => 'add_trailing_commas';
  
  @override
  String get description => 'Adds trailing commas to argument lists';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    final visitor = _TrailingCommaVisitor();
    unit.accept(visitor);
    
    if (visitor.modifications.isEmpty) {
      return AutoFixResult(
        content: content,
        wasModified: false,
        fixesApplied: 0,
      );
    }
    
    String modifiedContent = content;
    int offset = 0;
    
    for (final mod in visitor.modifications) {
      final position = mod.offset + offset;
      modifiedContent = '${modifiedContent.substring(0, position)},${modifiedContent.substring(position)}';
      offset += 1;
    }
    
    return AutoFixResult(
      content: modifiedContent,
      wasModified: true,
      fixesApplied: visitor.modifications.length,
    );
  }
}

class _TrailingCommaVisitor extends RecursiveAstVisitor<void> {
  final List<_Modification> modifications = [];
  
  @override
  void visitArgumentList(ArgumentList node) {
    if (node.arguments.isNotEmpty && 
        !node.toString().endsWith(',)') && 
        node.arguments.length > 2) {
      final lastArg = node.arguments.last;
      modifications.add(_Modification(lastArg.end));
    }
    super.visitArgumentList(node);
  }
}

/// Fix to remove magic numbers
class RemoveMagicNumberFix extends AutoFix {
  @override
  String get name => 'remove_magic_numbers';
  
  @override
  String get description => 'Replaces magic numbers with named constants';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    // Simplified implementation
    return AutoFixResult(
      content: content,
      wasModified: false,
      fixesApplied: 0,
    );
  }
}

/// Fix to add mounted checks
class AddMountedCheckFix extends AutoFix {
  @override
  String get name => 'add_mounted_check';
  
  @override
  String get description => 'Adds mounted checks after async operations';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    // Simplified implementation
    return AutoFixResult(
      content: content,
      wasModified: false,
      fixesApplied: 0,
    );
  }
}

/// Fix to simplify conditionals
class SimplifyConditionalFix extends AutoFix {
  @override
  String get name => 'simplify_conditionals';
  
  @override
  String get description => 'Simplifies nested conditionals using early returns';
  
  @override
  AutoFixResult apply(String content, CompilationUnit unit) {
    // Simplified implementation
    return AutoFixResult(
      content: content,
      wasModified: false,
      fixesApplied: 0,
    );
  }
}

class _Modification {
  final int offset;
  
  _Modification(this.offset);
} 