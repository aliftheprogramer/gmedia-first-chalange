import 'package:equatable/equatable.dart';
// category response entity removed from success state as create returns void

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
  const AddCategorySuccess();

  @override
  List<Object?> get props => [];
}

class AddCategoryFailure extends AddCategoryState {
  final String message;
  const AddCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
