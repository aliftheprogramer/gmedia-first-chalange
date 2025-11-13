import 'package:equatable/equatable.dart';

class AddCategoryFormState extends Equatable {
  final String name;

  const AddCategoryFormState({this.name = ''});

  AddCategoryFormState copyWith({String? name}) {
    return AddCategoryFormState(name: name ?? this.name);
  }

  @override
  List<Object?> get props => [name];
}
