import 'package:equatable/equatable.dart';

class AddProductFormState extends Equatable {
  final String name;
  final String priceText;
  final String? selectedCategoryId;
  final String? pickedPath;

  const AddProductFormState({
    this.name = '',
    this.priceText = '',
    this.selectedCategoryId,
    this.pickedPath,
  });

  AddProductFormState copyWith({
    String? name,
    String? priceText,
    String? selectedCategoryId,
    String? pickedPath,
  }) {
    return AddProductFormState(
      name: name ?? this.name,
      priceText: priceText ?? this.priceText,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      pickedPath: pickedPath ?? this.pickedPath,
    );
  }

  @override
  List<Object?> get props => [name, priceText, selectedCategoryId, pickedPath];
}
