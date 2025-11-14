import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_product_form_state.dart';
import 'dart:typed_data';

class AddProductFormCubit extends Cubit<AddProductFormState> {
  AddProductFormCubit() : super(const AddProductFormState());

  void setName(String name) => emit(state.copyWith(name: name));
  void setPriceText(String priceText) => emit(state.copyWith(priceText: priceText));
  void setCategoryId(String? categoryId) => emit(state.copyWith(selectedCategoryId: categoryId));
  void setPickedPath(String? path) => emit(state.copyWith(pickedPath: path));
  void setPickedMeta({String? path, String? fileName, int? size, Uint8List? bytes}) => emit(state.copyWith(pickedPath: path, pickedFileName: fileName, pickedFileSize: size, pickedBytes: bytes, clearError: true));
  void setUploadError(String message) => emit(state.copyWith(errorMessage: message));
  void clearPickedFile() => emit(state.copyWith(pickedPath: null, pickedFileName: null, pickedFileSize: null, pickedBytes: null, clearError: true));
  void reset() => emit(const AddProductFormState());
}
