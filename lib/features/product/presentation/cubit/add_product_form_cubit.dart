import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_product_form_state.dart';

class AddProductFormCubit extends Cubit<AddProductFormState> {
  AddProductFormCubit() : super(const AddProductFormState());

  void setName(String name) => emit(state.copyWith(name: name));
  void setPriceText(String priceText) => emit(state.copyWith(priceText: priceText));
  void setCategoryId(String? categoryId) => emit(state.copyWith(selectedCategoryId: categoryId));
  void setPickedPath(String? path) => emit(state.copyWith(pickedPath: path));
  void setPickedMeta({String? path, String? fileName, int? size}) => emit(state.copyWith(pickedPath: path, pickedFileName: fileName, pickedFileSize: size, clearError: true));
  void setUploadError(String message) => emit(state.copyWith(errorMessage: message));
  void reset() => emit(const AddProductFormState());
}
