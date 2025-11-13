import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/category/domain/usecase/create_new_category_usecase.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_state.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final CreateNewCategoryUsecase _createNewCategoryUsecase;

  AddCategoryCubit(this._createNewCategoryUsecase)
      : super(const AddCategoryInitial());

  Future<void> submit(String name) async {
    if (name.trim().isEmpty) {
      emit(const AddCategoryFailure('Nama kategori tidak boleh kosong'));
      return;
    }
    emit(const AddCategorySubmitting());
    try {
      final res = await _createNewCategoryUsecase.call(param: name.trim());
      if (res is DataSuccess && res.data != null) {
        emit(AddCategorySuccess(res.data!));
      } else {
        final msg = res is DataFailed
            ? (res.error?.message ?? 'Gagal menambah kategori')
            : 'Gagal menambah kategori';
        emit(AddCategoryFailure(msg));
      }
    } catch (e) {
      emit(AddCategoryFailure(e.toString()));
    }
  }
}
