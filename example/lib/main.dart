import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_design_editor/flutter_design_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Design Editor Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await [Permission.photos, Permission.storage].request();
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  if (context.mounted) {
                    final editedFile = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                FlutterDesignEditor(filePath: pickedFile.path),
                      ),
                    );
                    setState(() {
                      image = editedFile;
                    });
                    print('editedFile: ${image?.path}');
                  }
                }
              },
              child: const Text('Pick Image'),
            ),
            if (image != null) Expanded(child: Image.file(image!)),
          ],
        ),
      ),
    );
  }
}
