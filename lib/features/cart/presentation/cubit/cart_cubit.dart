import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/cart/domain/entity/cart_item_entity.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/cart_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:logger/logger.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial()) {
    // Initialize with empty cart
    emit(const CartLoaded([]));
  }

  final _logger = sl<Logger>();

  void addProduct(ProductEntityResponse product, {int quantity = 1}) {
    if (state is CartLoaded) {
      final currentItems = List<CartItemEntity>.from(
        (state as CartLoaded).items,
      );

      // Check if product already exists in cart
      final existingIndex = currentItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex != -1) {
        // Update quantity if exists
        currentItems[existingIndex] = currentItems[existingIndex].copyWith(
          quantity: currentItems[existingIndex].quantity + quantity,
        );
        _logger.i(
          'Updated cart: ${product.name}, new qty: ${currentItems[existingIndex].quantity}',
        );
      } else {
        // Add new item
        currentItems.add(CartItemEntity(product: product, quantity: quantity));
        _logger.i('Added to cart: ${product.name}, qty: $quantity');
      }

      emit(CartLoaded(currentItems));
    }
  }

  void removeProduct(String productId) {
    if (state is CartLoaded) {
      final currentItems = List<CartItemEntity>.from(
        (state as CartLoaded).items,
      );
      currentItems.removeWhere((item) => item.product.id == productId);
      _logger.i('Removed from cart: $productId');
      emit(CartLoaded(currentItems));
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (state is CartLoaded) {
      if (newQuantity <= 0) {
        removeProduct(productId);
        return;
      }

      final currentItems = List<CartItemEntity>.from(
        (state as CartLoaded).items,
      );
      final index = currentItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index != -1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: newQuantity,
        );
        _logger.i(
          'Updated quantity: ${currentItems[index].product.name}, qty: $newQuantity',
        );
        emit(CartLoaded(currentItems));
      }
    }
  }

  void clearCart() {
    _logger.i('Cart cleared');
    emit(const CartLoaded([]));
  }
}
