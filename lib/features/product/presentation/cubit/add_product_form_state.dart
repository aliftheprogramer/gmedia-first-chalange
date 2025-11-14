import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class AddProductFormState extends Equatable {
  final String name;
  final String priceText;
  final String? selectedCategoryId;
  final String? pickedPath;
  final String? pickedFileName; // original name
  final int? pickedFileSize; // bytes length
  final String? errorMessage; // upload validation error
  final Uint8List? pickedBytes; // raw bytes (web or fallback)

  const AddProductFormState({
    this.name = '',
    this.priceText = '',
    this.selectedCategoryId,
    this.pickedPath,
    this.pickedFileName,
    this.pickedFileSize,
    this.errorMessage,
    this.pickedBytes,
  });

  AddProductFormState copyWith({
    String? name,
    String? priceText,
    String? selectedCategoryId,
    String? pickedPath,
    String? pickedFileName,
    int? pickedFileSize,
    String? errorMessage,
    Uint8List? pickedBytes,
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
      pickedBytes: pickedBytes ?? this.pickedBytes,
    );
  }

  @override
  List<Object?> get props => [name, priceText, selectedCategoryId, pickedPath, pickedFileName, pickedFileSize, errorMessage, pickedBytes];
}
