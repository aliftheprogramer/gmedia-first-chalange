// lib/features/product/data/models/product_request_model.dart

import 'package:dio/dio.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';

class ProductRequestModel extends ProductRequestEntity {
  ProductRequestModel({
    required super.categoryId,
    required super.name,
    required super.price,
    required super.picture,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'category_id': categoryId,
      'name': name,
      'price': price,
      'picture': await MultipartFile.fromFile(
        picture.path,
        filename: picture.path.split('/').last, 
      ),
    });
  }
}