// lib/features/product/domain/entity/product_entity_response.dart

class ProductEntityResponse {
  final String id;
  final String categoryId;
  final String name;
  final int price;
  final String pictureUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ProductEntityResponse({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.pictureUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}
