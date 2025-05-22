import 'package:touch_craft_editor/touch_craft_editor.dart';

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
