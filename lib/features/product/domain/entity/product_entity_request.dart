// Cross-platform product request entity supporting file path or raw bytes.
// Avoids direct dart:io usage so it compiles on web.

import 'dart:typed_data';

class ProductRequestEntity {
  final String categoryId;
  final String name;
  final num price;
  final String? picturePath; // device path (mobile/desktop)
  final Uint8List? pictureBytes; // raw bytes (web or fallback)
  final String pictureFilename; // original name for multipart

  ProductRequestEntity({
    required this.categoryId,
    required this.name,
    required this.price,
    required this.pictureFilename,
    this.picturePath,
    this.pictureBytes,
  }) : assert(picturePath != null || pictureBytes != null, 'Either picturePath or pictureBytes must be provided');
}