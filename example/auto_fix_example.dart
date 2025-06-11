import 'package:flutter/material.dart';
import 'package:flutter_quality_lints/flutter_quality_lints.dart';

void main() async {
  // Create an instance of the auto-fix engine
  final AutoFixEngine autoFixEngine = AutoFixEngine();
  
  // List all available fixes
  debugPrint('Available fixes:');
  for (final String fix in autoFixEngine.getAvailableFixes()) {
    debugPrint('  - $fix');
  }
  
  // Apply fixes to a specific file
  debugPrint('\nApplying fixes to a file...');
  final FixResult fileResult = await autoFixEngine.fixFile('lib/widgets/my_widget.dart');
  
  if (fileResult.success) {
    debugPrint('✓ ${fileResult.message}');
    debugPrint('  Fixes applied: ${fileResult.fixesApplied}');
  } else {
    debugPrint('✗ ${fileResult.message}');
  }
  
  // Apply fixes to entire directory
  debugPrint('\nApplying fixes to entire directory...');
  final DirectoryFixResult dirResult = await autoFixEngine.fixDirectory('lib');
  
  if (dirResult.success) {
    debugPrint('✓ ${dirResult.message}');
    debugPrint('  Files processed: ${dirResult.filesProcessed}');
    debugPrint('  Total fixes: ${dirResult.totalFixes}');
    
    if (dirResult.modifiedFiles.isNotEmpty) {
      debugPrint('  Modified files:');
      for (final String file in dirResult.modifiedFiles) {
        debugPrint('    - $file');
      }
    }
  } else {
    debugPrint('✗ ${dirResult.message}');
  }
}

// Ejemplo de código que se puede auto-corregir
class ExampleWidget extends StatefulWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Fix Example'), // Falta const
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0), // Falta const
            child: const Text('Hello World'), // Falta const
          ),
          ElevatedButton(
            onPressed: () async {
              await Future<void>.delayed(const Duration(seconds: 1));
              // Falta verificación de mounted
              Navigator.of(context).pop();
            },
            child: const Text('Click Me') // Falta const y trailing comma
          )
        ] // Falta trailing comma
      ),
    );
  }
} 