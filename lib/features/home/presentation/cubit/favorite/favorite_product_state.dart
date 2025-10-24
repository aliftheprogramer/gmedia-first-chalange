import 'package:equatable/equatable.dart';

abstract class FavoriteProductState extends Equatable {
  const FavoriteProductState();

  @override
  List<Object?> get props => [];
}

class FavoriteProductInitial extends FavoriteProductState {
  const FavoriteProductInitial();
}

class FavoriteProductLoading extends FavoriteProductState {
  const FavoriteProductLoading();
}

class FavoriteProductLoaded extends FavoriteProductState {
  final List<dynamic> products;
  const FavoriteProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class FavoriteProductEmpty extends FavoriteProductState {
  const FavoriteProductEmpty();
}

class FavoriteProductAdded extends FavoriteProductState {
  final dynamic product;
  const FavoriteProductAdded(this.product);

  @override
  List<Object?> get props => [product];
}

class FavoriteProductRemoved extends FavoriteProductState {
  final dynamic product;
  const FavoriteProductRemoved(this.product);

  @override
  List<Object?> get props => [product];
}

class FavoriteProductError extends FavoriteProductState {
  final String message;
  const FavoriteProductError(this.message);

  @override
  List<Object?> get props => [message];
}
