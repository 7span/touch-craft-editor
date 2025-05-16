import 'package:flutter_design_editor/flutter_design_editor.dart';

ItemType stringToItemType(String value) {
  if (value == 'image') {
    return ItemType.image;
  } else if (value == 'sticker') {
    return ItemType.sticker;
  } else if (value == 'gif') {
    return ItemType.gif;
  } else {
    return ItemType.text;
  }
}
