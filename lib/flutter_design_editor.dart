import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'src/components/background_gradient_selector_widget.dart';
import 'src/components/font_family_select_widget.dart';
import 'src/components/footer_tools_widget.dart';
import 'src/components/overlay_item_widget.dart';
import 'src/components/remove_widget.dart';
import 'src/components/size_slider_widget.dart';
import 'src/components/text_color_select_widget.dart';
import 'src/components/text_field_widget.dart';
import 'src/components/top_tools_widget.dart';
import 'src/constants/font_colors.dart';
import 'src/constants/gradients.dart';
import 'src/constants/item_type.dart';
import 'src/extensions/context_extension.dart';
import 'src/models/editable_items.dart';

class FlutterDesignEditor extends StatefulWidget {
  const FlutterDesignEditor({
    super.key,
    required this.filePath,
    this.animationsDuration = const Duration(milliseconds: 300),
    this.doneButtonChild,
  });

  final String filePath;
  final Duration animationsDuration;
  final Widget? doneButtonChild;

  @override
  State<FlutterDesignEditor> createState() => _FlutterDesignEditorState();
}

class _FlutterDesignEditorState extends State<FlutterDesignEditor> {
  // A global key used to get the context of the widget tree.
  GlobalKey previewContainer = GlobalKey();

  // The currently active editable item.
  EditableItem? _activeItem;

  // The initial position of the active item.
  Offset _initPos = Offset.zero;

  // The current position of the active item.
  Offset _currentPos = Offset.zero;

  // The current scale of the active item.
  double _currentScale = 1;

  // The current rotation of the active item.
  double _currentRotation = 0;

  // Indicates whether the widget is in action.
  bool _inAction = false;

  // Indicates whether the widget is in text input mode.
  bool _isTextInput = false;

  // The current text in the text input field.
  String _currentText = '';

  // The currently selected text color.
  Color _selectedTextColor = const Color(0xffffffff);

  // The index of the currently selected text background gradient.
  int _selectedTextBackgroundGradient = 0;

  // The index of the currently selected background gradient.
  int _selectedBackgroundGradient = 0;

  // The currently selected font size.
  double _selectedFontSize = 26;

  // The index of the currently selected font family.
  int _selectedFontFamily = 0;

  // Indicates whether the widget is in delete position.
  bool _isDeletePosition = false;

  // Indicates whether the color picker is selected.
  bool _isColorPickerSelected = false;

  // Indicates whether the background color picker is selected.
  bool _isBackgroundColorPickerSelected = false;

  // Indicates whether the widget is in loading state.
  bool _isLoading = false;

  // The controller for the font family PageView.
  late PageController _familyPageController;

  // The controller for the text colors PageView.
  late PageController _textColorsPageController;

  // The controller for the gradients PageView.
  late PageController _gradientsPageController;

  // The controller for the text editing field.
  final _editingController = TextEditingController();

  // The stack data for the editable items.
  final _stackData = <EditableItem>[];

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each [State] object it creates.
  /// This method is where you should put any expensive computations, network calls, initializations, or subscriptions.
  /// In this case, it calls the [_init] method to initialize the state of the widget.
  @override
  void initState() {
    super.initState();
    _init();
  }

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never build again.
  /// This method is where you should unsubscribe or dispose any resources, streams, or animations that were created in [initState].
  @override
  void dispose() {
    _editingController.dispose();
    _familyPageController.dispose();
    _textColorsPageController.dispose();
    _gradientsPageController.dispose();
    super.dispose();
  }

  /// Initializes the state of the widget.
  ///
  /// This method is called in [initState] to set up the initial state of the widget.
  /// It initializes the [_stackData] with an [EditableItem] of type [ItemType.image] and the value of [widget.filePath].
  /// It also initializes the [_familyPageController], [_textColorsPageController], and [_gradientsPageController] with their respective viewport fractions.
  void _init() {
    _stackData.add(
      EditableItem()
        ..type = ItemType.image
        ..value = widget.filePath,
    );
    _familyPageController = PageController(viewportFraction: .125);
    _textColorsPageController = PageController(viewportFraction: .1);
    _gradientsPageController = PageController(viewportFraction: .175);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        leadingDistribution: TextLeadingDistribution.even,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              top: context.topPadding,
              left: 0,
              right: 0,
              child: ClipRect(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    onTap: _onScreenTap,
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          key: previewContainer,
                          child: Stack(
                            children: [
                              Visibility(
                                visible: _stackData[0].type == ItemType.image,
                                child: Center(
                                  child: PhotoView(
                                    enableRotation: true,
                                    backgroundDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.centerRight,
                                        colors:
                                            gradientColors[_selectedBackgroundGradient],
                                      ),
                                    ),
                                    maxScale: 2.0,
                                    enablePanAlways: false,
                                    imageProvider: FileImage(
                                      File(_stackData[0].value),
                                    ),
                                  ),
                                ),
                              ),
                              ..._stackData.map(
                                (editableItem) => OverlayItemWidget(
                                  editableItem: editableItem,
                                  onItemTap: () {
                                    _onOverlayItemTap(editableItem);
                                  },
                                  onPointerDown: (details) {
                                    _onOverlayItemPointerDown(
                                      editableItem,
                                      details,
                                    );
                                  },
                                  onPointerUp: (details) {
                                    _onOverlayItemPointerUp(
                                      editableItem,
                                      details,
                                    );
                                  },
                                  onPointerMove: (details) {
                                    _onOverlayItemPointerMove(
                                      editableItem,
                                      details,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: widget.animationsDuration,
                          child:
                              !_isTextInput
                                  ? const SizedBox()
                                  : Container(
                                    height: context.height,
                                    width: context.width,
                                    color: Colors.black.withValues(alpha: 0.4),
                                    child: Stack(
                                      children: [
                                        TextFieldWidget(
                                          controller: _editingController,
                                          onChanged: _onTextChange,
                                          onSubmit: _onTextSubmit,
                                          fontSize: _selectedFontSize,
                                          fontFamilyIndex: _selectedFontFamily,
                                          textColor: _selectedTextColor,
                                          backgroundColorIndex:
                                              _selectedTextBackgroundGradient,
                                        ),
                                        SizeSliderWidget(
                                          animationsDuration:
                                              widget.animationsDuration,
                                          selectedValue: _selectedFontSize,
                                          onChanged: (input) {
                                            setState(() {
                                              _selectedFontSize = input;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isTextInput)
              if (!_isColorPickerSelected)
                FontFamilySelectWidget(
                  animationsDuration: widget.animationsDuration,
                  pageController: _familyPageController,
                  selectedFamilyIndex: _selectedFontFamily,
                  onPageChanged: _onFamilyChange,
                  onTap: (index) {
                    _onStyleChange(index);
                  },
                )
              else
                TextColorSelectWidget(
                  animationsDuration: widget.animationsDuration,
                  pageController: _textColorsPageController,
                  selectedTextColor: _selectedTextColor,
                  onPageChanged: _onTextColorChange,
                  onTap: (index) {
                    _onColorChange(index);
                  },
                ),
            BackgroundGradientSelectorWidget(
              isTextInput: _isTextInput,
              isBackgroundColorPickerSelected: _isBackgroundColorPickerSelected,
              inAction: _inAction,
              animationsDuration: widget.animationsDuration,
              gradientsPageController: _gradientsPageController,
              onPageChanged: _onChangeBackgroundGradient,
              onItemTap: _onBackgroundGradientTap,
              selectedGradientIndex: _selectedBackgroundGradient,
            ),
            TopToolsWidget(
              isTextInput: _isTextInput,
              selectedBackgroundGradientIndex: _selectedBackgroundGradient,
              animationsDuration: widget.animationsDuration,
              onPickerTap: _onToggleBackgroundGradientPicker,
              onScreenTap: _onScreenTap,
              selectedTextBackgroundGradientIndex:
                  _selectedTextBackgroundGradient,
              onToggleTextColorPicker: _onToggleTextColorSelector,
              onChangeTextBackground: _onChangeTextBackground,
              activeItem: _activeItem,
            ),
            RemoveWidget(
              isTextInput: _isTextInput,
              animationsDuration: widget.animationsDuration,
              activeItem: _activeItem,
              isDeletePosition: _isDeletePosition,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FooterToolsWidget(
                onDone: _onDone,
                doneButtonChild: widget.doneButtonChild,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the submission of text input.
  ///
  /// This method is called when the user submits the text input field.
  /// If the input is not empty, it calls the [_onSubmitText] method to add the text to the stack data.
  /// If the input is empty, it resets the [_currentText] to an empty string.
  /// In either case, it toggles the [_isTextInput] flag to exit the text input mode and sets the [_activeItem] to null.
  void _onTextSubmit(String input) {
    if (input.isNotEmpty) {
      setState(_onSubmitText);
    } else {
      setState(() {
        _currentText = '';
      });
    }

    setState(() {
      _isTextInput = !_isTextInput;
      _activeItem = null;
    });
  }

  /// Handles the change of text input.
  ///
  /// This method is called when the user types into the text input field.
  /// It updates the [_currentText] with the new input.
  void _onTextChange(input) {
    setState(() {
      _currentText = input;
    });
  }

  /// Changes the background of the text.
  ///
  /// This method is called when the user taps on the text background change button.
  /// It increments the [_selectedTextBackgroundGradient] index if it's less than the length of [gradientColors] array.
  /// If the index has reached the end of the array, it resets it to 0.
  void _onChangeTextBackground() {
    if (_selectedTextBackgroundGradient < gradientColors.length - 1) {
      setState(() {
        _selectedTextBackgroundGradient++;
      });
    } else {
      setState(() {
        _selectedTextBackgroundGradient = 0;
      });
    }
  }

  /// Toggles the text color selector.
  ///
  /// This method is called when the user taps on the text color selector button.
  /// It toggles the [_isColorPickerSelected] flag to show or hide the color picker.
  void _onToggleTextColorSelector() {
    setState(() {
      _isColorPickerSelected = !_isColorPickerSelected;
    });
  }

  /// Handles the change of text color.
  ///
  /// This method is called when the user selects a new text color from the color picker.
  /// It updates the [_selectedTextColor] with the new color.
  /// The [index] parameter is the index of the selected color in the [defaultColors] list.
  void _onTextColorChange(index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTextColor = defaultColors[index];
    });
  }

  /// Handles the change of font family.
  ///
  /// This method is called when the user selects a new font family from the font family picker.
  /// It updates the [_selectedFontFamily] with the new font family.
  /// The [index] parameter is the index of the selected font family in the [fontFamilyList] list.
  void _onFamilyChange(index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFontFamily = index;
    });
  }

  /// Toggles the background gradient picker.
  ///
  /// This method is called when the user taps on the background gradient picker button.
  /// It toggles the [_isBackgroundColorPickerSelected] flag to show or hide the background gradient picker.
  void _onToggleBackgroundGradientPicker() {
    setState(() {
      _isBackgroundColorPickerSelected = !_isBackgroundColorPickerSelected;
    });
  }

  /// Handles the selection of a background gradient.
  ///
  /// This method is called when the user selects a new background gradient from the gradient picker.
  /// It updates the [_selectedBackgroundGradient] with the new gradient and jumps the [_gradientsPageController] to the selected page.
  /// The [index] parameter is the index of the selected gradient in the [gradientColors] list.
  void _onBackgroundGradientTap(index) {
    setState(() {
      _selectedBackgroundGradient = index;
      _gradientsPageController.jumpToPage(index);
    });
  }

  /// Handles the change of background gradient.
  ///
  /// This method is called when the user selects a new background gradient from the gradient picker.
  /// It updates the [_selectedBackgroundGradient] with the new gradient.
  /// The [index] parameter is the index of the selected gradient in the [gradientColors] list.
  void _onChangeBackgroundGradient(index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedBackgroundGradient = index;
    });
  }

  /// Handles the start of a scale gesture.
  ///
  /// This method is called when the user starts a scale gesture on the active item.
  /// It sets the [_initPos], [_currentPos], [_currentScale], and [_currentRotation] to the initial values of the gesture.
  /// The [details] parameter contains the details of the scale start gesture.
  void _onScaleStart(ScaleStartDetails details) {
    if (_activeItem == null) {
      return;
    }
    _initPos = details.focalPoint;
    _currentPos = _activeItem!.position;
    _currentScale = _activeItem!.scale;
    _currentRotation = _activeItem!.rotation;
  }

  /// Handles the update of a scale gesture.
  ///
  /// This method is called when the user updates a scale gesture on the active item.
  /// It calculates the new position, rotation, and scale of the active item based on the gesture details and updates the state.
  /// The [details] parameter contains the details of the scale update gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_activeItem == null) {
      return;
    }
    final delta = details.focalPoint - _initPos;
    final left = (delta.dx / context.width) + _currentPos.dx;
    final top = (delta.dy / context.height) + _currentPos.dy;

    setState(() {
      _activeItem!.position = Offset(left, top);
      _activeItem!.rotation = details.rotation + _currentRotation;
      _activeItem!.scale = details.scale * _currentScale;
    });
  }

  /// Handles the screen tap event.
  ///
  /// This method is called when the user taps on the screen.
  /// It toggles the [_isTextInput] flag to enter or exit the text input mode and sets the [_activeItem] to null.
  /// If the current text is not empty, it calls the [_onSubmitText] method to add the text to the stack data.
  /// It also initializes the [_familyPageController] and [_textColorsPageController] with their respective viewport fractions.
  void _onScreenTap() {
    setState(() {
      _isTextInput = !_isTextInput;
      _activeItem = null;
      _isBackgroundColorPickerSelected = false;
    });

    if (_currentText.isNotEmpty) {
      setState(_onSubmitText);
    }
    _familyPageController = PageController(
      initialPage: _selectedFontFamily,
      viewportFraction: .125,
    );
    _textColorsPageController = PageController(
      initialPage: defaultColors.indexWhere(
        (element) => element == _selectedTextColor,
      ),
      viewportFraction: .1,
    );
  }

  /// Handles the done event.
  ///
  /// This method is called when the user taps on the done button.
  /// It captures the current state of the widget as an image and saves it to the application documents directory.
  /// The image is saved as a png file with the current date and time as the file name.
  /// After the image is saved, it navigates back and passes the image file as the result of the navigation.
  Future<void> _onDone() async {
    final boundary =
        previewContainer.currentContext!.findRenderObject()
            as RenderRepaintBoundary?;
    _isLoading = true;
    setState(() {});
    final image = await boundary!.toImage(pixelRatio: 3);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final pngBytes = byteData.buffer.asUint8List();
    final imgFile = File('$directory/${DateTime.now()}.png');
    await imgFile.writeAsBytes(pngBytes);
    _isLoading = false;
    setState(() {});
    if (context.mounted) {
      Navigator.of(context).pop(imgFile);
    }
  }

  /// Handles the submission of text input.
  ///
  /// This method is called when the user submits the text input field.
  /// It adds a new [EditableItem] of type [ItemType.text] to the [_stackData] with the current text, text color, text style, font size, and font family.
  /// It then resets the [_editingController] and [_currentText] to an empty string.
  void _onSubmitText() {
    _stackData.add(
      EditableItem()
        ..type = ItemType.text
        ..value = _currentText
        ..color = _selectedTextColor
        ..textStyle = _selectedTextBackgroundGradient
        ..fontSize = _selectedFontSize
        ..fontFamily = _selectedFontFamily,
    );
    _editingController.text = '';
    _currentText = '';
  }

  /// Handles the change of font style.
  ///
  /// This method is called when the user selects a new font style from the style picker.
  /// It updates the [_selectedFontFamily] with the new style and jumps the [_familyPageController] to the selected page.
  /// The [index] parameter is the index of the selected style in the [fontFamilyList] list.
  void _onStyleChange(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFontFamily = index;
    });
    _familyPageController.jumpToPage(index);
  }

  /// Handles the change of text color.
  ///
  /// This method is called when the user selects a new text color from the color picker.
  /// It updates the [_selectedTextColor] with the new color and jumps the [_textColorsPageController] to the selected page.
  /// The [index] parameter is the index of the selected color in the [defaultColors] list.
  void _onColorChange(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTextColor = defaultColors[index];
    });
    _textColorsPageController.jumpToPage(index);
  }

  /// Handles the tap event on an overlay item.
  ///
  /// This method is called when the user taps on an overlay item.
  /// It toggles the [_isTextInput] flag to enter or exit the text input mode, sets the [_activeItem] to null, and updates the text and style properties based on the tapped item.
  /// It also removes the tapped item from the [_stackData] and initializes the [_familyPageController] and [_textColorsPageController] with their respective viewport fractions.
  /// The [e] parameter is the tapped [EditableItem].
  void _onOverlayItemTap(EditableItem e) {
    setState(() {
      _isTextInput = !_isTextInput;
      _activeItem = null;
      _editingController.text = e.value;
      _currentText = e.value;
      _selectedFontFamily = e.fontFamily;
      _selectedFontSize = e.fontSize;
      _selectedTextBackgroundGradient = e.textStyle;
      _selectedTextColor = e.color;
      _stackData.removeAt(_stackData.indexOf(e));
    });
    _familyPageController = PageController(
      initialPage: e.textStyle,
      viewportFraction: .1,
    );
    _textColorsPageController = PageController(
      initialPage: defaultColors.indexWhere((element) => element == e.color),
      viewportFraction: .1,
    );
  }

  /// Handles the pointer down event on an overlay item.
  ///
  /// This method is called when the user starts a pointer down gesture on an overlay item.
  /// If the item is not an image and the widget is not in action, it sets the [_inAction] flag to true and updates the initial values of the gesture.
  /// The [e] parameter is the [EditableItem] on which the gesture started.
  /// The [details] parameter contains the details of the pointer down gesture.
  void _onOverlayItemPointerDown(EditableItem e, PointerDownEvent details) {
    if (e.type != ItemType.image) {
      if (_inAction) {
        return;
      }
      _inAction = true;
      _activeItem = e;
      _initPos = details.position;
      _currentPos = e.position;
      _currentScale = e.scale;
      _currentRotation = e.rotation;
    }
  }

  /// Handles the pointer up event on an overlay item.
  ///
  /// This method is called when the user ends a pointer up gesture on an overlay item.
  /// It sets the [_inAction] flag to false and checks if the item is in the delete position.
  /// If the item is in the delete position, it removes the item from the [_stackData] and sets the [_activeItem] to null.
  /// The [e] parameter is the [EditableItem] on which the gesture ended.
  /// The [details] parameter contains the details of the pointer up gesture.
  void _onOverlayItemPointerUp(EditableItem e, PointerUpEvent details) {
    _inAction = false;
    if (e.position.dy >= 0.65 && e.position.dx >= 0.0 && e.position.dx <= 1.0) {
      setState(() {
        _stackData.removeAt(_stackData.indexOf(e));
        _activeItem = null;
      });
    }

    setState(() {
      _activeItem = null;
    });
  }

  /// Handles the pointer move event on an overlay item.
  ///
  /// This method is called when the user moves a pointer on an overlay item.
  /// It checks if the item is in the delete position and updates the [_isDeletePosition] flag accordingly.
  /// The [e] parameter is the [EditableItem] on which the pointer is moving.
  /// The [details] parameter contains the details of the pointer move gesture.
  void _onOverlayItemPointerMove(EditableItem e, PointerMoveEvent details) {
    if (e.position.dy >= 0.65 && e.position.dx >= 0.0 && e.position.dx <= 1.0) {
      setState(() {
        _isDeletePosition = true;
      });
    } else {
      setState(() {
        _isDeletePosition = false;
      });
    }
  }
}
