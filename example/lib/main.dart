import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/flutter_design_editor.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDesignEditor(
      imageFormatType: ImageFormatType.jpg,
      onDesignReady: (
        File? designFile,
        Map<String, dynamic> canvasElementJson,
      ) {
        if (kDebugMode) {
          print('canvasElementJson : $canvasElementJson');
        }
      },
    );
  }
}
