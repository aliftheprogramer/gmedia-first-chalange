import 'package:equatable/equatable.dart';

class AddProductFormState extends Equatable {
  final String name;
  final String priceText;
  final String? selectedCategoryId;
  final String? pickedPath;
  final String? pickedFileName; // original name
  final int? pickedFileSize; // bytes length
  final String? errorMessage; // upload validation error

  const AddProductFormState({
    this.name = '',
    this.priceText = '',
    this.selectedCategoryId,
    this.pickedPath,
    this.pickedFileName,
    this.pickedFileSize,
    this.errorMessage,
  });

  AddProductFormState copyWith({
    String? name,
    String? priceText,
    String? selectedCategoryId,
    String? pickedPath,
    String? pickedFileName,
    int? pickedFileSize,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddProductFormState(
      name: name ?? this.name,
      priceText: priceText ?? this.priceText,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      pickedPath: pickedPath ?? this.pickedPath,
      pickedFileName: pickedFileName ?? this.pickedFileName,
      pickedFileSize: pickedFileSize ?? this.pickedFileSize,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [name, priceText, selectedCategoryId, pickedPath, pickedFileName, pickedFileSize, errorMessage];
}
