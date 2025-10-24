import 'package:equatable/equatable.dart';

abstract class ProductSoldState extends Equatable {
  const ProductSoldState();

  @override
  List<Object?> get props => [];
}

class ProductSoldInitial extends ProductSoldState {
  const ProductSoldInitial();
}

class ProductSoldLoading extends ProductSoldState {
  const ProductSoldLoading();
}

class ProductSoldLoaded extends ProductSoldState {
  final List<dynamic> products;
  const ProductSoldLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductSoldEmpty extends ProductSoldState {
  const ProductSoldEmpty();
}

class ProductSoldError extends ProductSoldState {
  final String message;
  const ProductSoldError(this.message);

  @override
  List<Object?> get props => [message];
}
  