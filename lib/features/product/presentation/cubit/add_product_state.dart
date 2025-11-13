import 'package:equatable/equatable.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';

abstract class AddProductState extends Equatable {
	const AddProductState();

	@override
	List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {
	const AddProductInitial();
}

class AddProductSubmitting extends AddProductState {
	const AddProductSubmitting();
}

class AddProductSuccess extends AddProductState {
	final ProductEntityResponse product;
	const AddProductSuccess(this.product);

	@override
	List<Object?> get props => [product];
}

class AddProductFailure extends AddProductState {
	final String message;
	const AddProductFailure(this.message);

	@override
	List<Object?> get props => [message];
}

