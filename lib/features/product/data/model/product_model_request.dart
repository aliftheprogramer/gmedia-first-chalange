import 'package:dio/dio.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';

class ProductRequestModel extends ProductRequestEntity {
  ProductRequestModel({
    required super.categoryId,
    required super.name,
    required super.price,
    required super.pictureFilename,
    super.picturePath,
    super.pictureBytes,
  });

  Future<FormData> toFormData() async {
    final MultipartFile multipart;
    if (pictureBytes != null) {
      multipart = MultipartFile.fromBytes(pictureBytes!, filename: pictureFilename);
    } else {
      multipart = await MultipartFile.fromFile(picturePath!, filename: pictureFilename);
    }
    return FormData.fromMap({
      'category_id': categoryId,
      'name': name,
      'price': price,
      'picture': multipart,
    });
  }
}