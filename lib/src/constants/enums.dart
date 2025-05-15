/// Enum representing the type of an item.
///
/// This enum is used throughout the application to differentiate between different types of items.
/// Currently, it includes all types including image, text, sticker and gif.
enum ItemType { image, text, sticker, gif }

/// Enum representing supported image export formats.
///
/// This enum is used to define the image format when saving a design to local storage.
/// Currently supports PNG and JPG formats.
enum ImageFormatType { png, jpg }
