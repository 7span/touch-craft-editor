#  TouchCraft Editor

Craft stunning visual editors with Flutter. 🎨 Add text, GIFs, stickers, gradients, and images — customize everything, export anywhere, and re-edit anytime.

![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.24.0-blue.svg)
![Dart](https://img.shields.io/badge/dart-%5E3.3.0-blue.svg)
![Version](https://img.shields.io/badge/version-0.0.1-success.svg)

## Overview

![flutter_package.mp4](flutter_package.mp4)

## Getting started

```dart
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCraftEditor(
      onDesignReady:
          (designFile, backgroundGradientColorList, canvasElementList) {},
    );
  }
}
```

## Note this :

To avoid build-time warnings follow this steps.
1. Create proguard-rules.pro file at **your_application/android/app/proguard-rules.pro**.
2. Add following line of code.
```
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options
```

If you are using the create sticker feature, you must include the required ML model.
1. Download the model from this [link](https://github.com/dailystudio/ml/blob/master/deeplab/app/src/main/assets/deeplabv3_257_mv_gpu.tflite).
2. Create a directory in your Flutter project: **assets/models/**.
3. Move the downloaded deeplabv3_257_mv_gpu.tflite file into this directory.



## 🛠️ Core Features
**Image Editing** : Add, crop, scale, rotate images

**Text Editing** : Customize background, text color, font size & style.

**GIF Support** : Add GIFs via GIPHY.

**Sticker Features** : Create custom stickers from gallery images.

**Backgrounds** : Apply solid colors or gradients.

**Re-Editable Designs** : Load and modify existing designs with full fidelity.

**Layer-Based Design** : Move, stack, rotate, and scale elements like in design tools.


## 🧩 Customization & Flexibility


**Toggle Editing Features** : 
- Choose which tools to expose (image, GIF, sticker, text, gradient).

**Customizable Theming Support** : 
- Primary color configuration for quick minimal setup
- Fully customizable UI to match your app’s design.

**Cross-Platform** :
- 100% compatible with Android & iOS.

**Export Options** : 
- Save as PNG, JPG, or animated GIF.

## Usage
Provide TouchCraftEditor widget directly to screen.
```dart
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCraftEditor(
      onDesignReady:
          (designFile, backgroundGradientColorList, canvasElementList) {},
    );
  }
}
```
--- 
**onDesignReady** is required method to be override. It returns following three items.
1. **designFile** : A image in form of png or jpg or an GIF format as per provided.
2. **backgroundGradientColorList** : if image or GIF contains background gradient then it is returned by this parameter.
3. **canvasElementList** : The list of all CanvasElement models will be returned which was used in image/GIF. 


```dart
onDesignReady : (designFile , backgroundGradientColorList, canvasElementList) {},
```

Note : Incase where you want to store image/GIF data in JSON formate or want to re-edit the same image to pass in **TouchCraftEditor** canvasElementList will come handy.

---

Cutsomise the canvas editor as per your choice as you can enable ediiting features as per your app's requirement with following parameters.

**Note : All parameters are set to true bydefault.**

```dart
      TouchCraftEditor(
        enableBackgroundGradientEditor: true,
        enableGifEditor: true,
        enableImageEditor: false,
        enableStickerEditor: true,
        enableTextEditor: false,
        onDesignReady:
            (designFile, backgroundGradientColorList, canvasElementList) {},
      ),
```
---

Use imageFormatType parameter to provide image type for exporting via **ImageFormatType** enum.

```dart
    TouchCraftEditor(
        imageFormatType: ImageFormatType.jpg,
        ...
```
---

Provide the duration for all animated transitions within the widget.

```dart
    TouchCraftEditor(
        animationsDuration: Duration(milliseconds: 500),
        ...
```
---

Provide customised colors and google fontFamily list for font and background gradient customisation.

```dart
    TouchCraftEditor(
        backgroundGradientColorList: [
          [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          [Color(0xFFb92b27), Color(0xFF1565C0)],
          [Color(0xFF373B44), Color(0xFF4286f4)],
        ],
        fontFamilyList: ['Lato', 'Montserrat', 'Lobster'],
        fontColorList: [Colors.black, Colors.white, Colors.red],
```
---
Set primary color to match your app's theme

```dart
    TouchCraftEditor(
      primaryColor: Colors.green,
      ...
    );
```
--- 
### Customize Editor UI

- You can set your own widgets for icons, buttons, and actions using parameters like doneButtonChild, internetConnectionWidget.
- This allows full control over the look and feel to match your app’s branding.

Example 1: Custom "Done" Button
```dart
TouchCraftEditor(
  onDesignReady: (image) {
    // Handle exported image
  },
  doneButtonChild: ElevatedButton(
    onPressed: () {
      // Custom action
    },
    child: Text("Finish"),
  ),
)
```

Example 2: Custom "No Internet" Widget

```dart
TouchCraftEditor(
  onDesignReady: (image) {},
  internetConnectionWidget: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.wifi_off, size: 48),
        Text("Please check your internet connection"),
      ],
    ),
  ),
)
```
# 🤝 Contribution

Contributions are welcome! If you have suggestions, improvements, or bug fixes, please open an issue
or submit a pull request.

1. Fork the repository.
2. Create an issue for related changes.
3. Create a new branch (feature-branch)
4. Commit your changes.
5. Push to the branch and submit a pull request.

