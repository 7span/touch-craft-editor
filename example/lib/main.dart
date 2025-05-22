import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:touch_craft_editor/touch_craft_editor.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCraftEditor(
      primaryColor: Colors.blue,
      imageFormatType: ImageFormatType.jpg,
      onDesignReady: (File? designFile, Map<String, dynamic> canvasDesignJson) {
        if (kDebugMode) {
          print('canvasElementJson : $canvasDesignJson');
        }
      },
    );
  }
}
