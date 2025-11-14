// lib/features/product/data/models/product_model.dart

import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';

class ProductResponseModel extends ProductEntityResponse {
  ProductResponseModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.price,
    required super.pictureUrl,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    // Normalize data coming from POST where everything may be string
    final dynamic priceRaw = json['price'];
    int priceInt;
    if (priceRaw is int) {
      priceInt = priceRaw;
    } else if (priceRaw is num) {
      priceInt = priceRaw.toInt();
    } else if (priceRaw is String) {
      priceInt = int.tryParse(priceRaw) ?? 0;
    } else {
      priceInt = 0;
    }

    return ProductResponseModel(
      id: (json['id'] ?? '').toString(),
      categoryId: (json['category_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: priceInt,
      pictureUrl: (json['picture_url'] ?? '').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'picture_url': pictureUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  ProductEntityResponse toEntity() {
    return ProductEntityResponse(
      id: id,
      categoryId: categoryId,
      name: name,
      price: price,
      pictureUrl: pictureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

