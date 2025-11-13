import 'package:equatable/equatable.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';

abstract class AddCategoryState extends Equatable {
  const AddCategoryState();

  @override
  List<Object?> get props => [];
}

class AddCategoryInitial extends AddCategoryState {
  const AddCategoryInitial();
}

class AddCategorySubmitting extends AddCategoryState {
  const AddCategorySubmitting();
}

class AddCategorySuccess extends AddCategoryState {
  final CategoryEntityResponse category;
  const AddCategorySuccess(this.category);

  @override
  List<Object?> get props => [category];
}

class AddCategoryFailure extends AddCategoryState {
  final String message;
  const AddCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
