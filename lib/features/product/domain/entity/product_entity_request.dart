// lib/features/product/domain/entities/product_request_entity.dart

import 'dart:io';

class ProductRequestEntity {
  final String categoryId;
  final String name;
  final num price;
  final File picture;

  ProductRequestEntity({
    required this.categoryId,
    required this.name,
    required this.price,
    required this.picture,
  });
}