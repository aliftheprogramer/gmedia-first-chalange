import 'package:equatable/equatable.dart';

abstract class ProductSellState extends Equatable {
  const ProductSellState();

  @override
  List<Object?> get props => [];
}

class ProductSellInitial extends ProductSellState {
  const ProductSellInitial();
}

class ProductSellLoading extends ProductSellState {
  const ProductSellLoading();
}

class ProductSellLoaded extends ProductSellState {
  final List<dynamic> products;
  const ProductSellLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductSellEmpty extends ProductSellState {
  const ProductSellEmpty();
}

class ProductSellError extends ProductSellState {
  final String message;
  const ProductSellError(this.message);

  @override
  List<Object?> get props => [message];
}
  