// lib/features/product/domain/usecase/edit_product_usecase.dart

import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';

// Kelas untuk membungkus parameter yang dibutuhkan oleh use case
class EditProductParams {
  final String id;
  final ProductRequestEntity request;

  EditProductParams({required this.id, required this.request});
}