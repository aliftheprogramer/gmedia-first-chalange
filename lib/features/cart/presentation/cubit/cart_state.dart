import 'package:equatable/equatable.dart';
import 'package:gmedia_project/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;

  const CartLoaded(this.items);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object?> get props => [items];
}
