import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';

class CartItemEntity {
  final ProductEntityResponse product;
  final int quantity;

  CartItemEntity({required this.product, required this.quantity});

  CartItemEntity copyWith({ProductEntityResponse? product, int? quantity}) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  int get totalPrice => product.price * quantity;
}
