import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/category/domain/usecase/create_new_category_usecase.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_state.dart';
import 'package:logger/logger.dart';

final Logger _log = Logger();

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final CreateNewCategoryUsecase _createNewCategoryUsecase;

  AddCategoryCubit(this._createNewCategoryUsecase)
      : super(const AddCategoryInitial());

  void reset() {
    emit(const AddCategoryInitial());
  }

  Future<void> submit(String name) async {
    if (name.trim().isEmpty) {
      _log.i('[AddCategoryCubit] validation failed: empty name');
      emit(const AddCategoryFailure('Nama kategori tidak boleh kosong'));
      return;
    }
    _log.i('[AddCategoryCubit] submitting category name="$name"');
    emit(const AddCategorySubmitting());
    try {
      final res = await _createNewCategoryUsecase.call(param: name.trim());
  _log.i('[AddCategoryCubit] submit response type=${res.runtimeType} error=${res.error}');
      if (res is DataSuccess) {
        _log.i('[AddCategoryCubit] create succeeded');
        emit(const AddCategorySuccess());
      } else {
        final msg = res is DataFailed
            ? (res.error?.message ?? 'Gagal menambah kategori')
            : 'Gagal menambah kategori';
        _log.i('[AddCategoryCubit] create failed: $msg');
        emit(AddCategoryFailure(msg));
      }
    } catch (e) {
      _log.e('[AddCategoryCubit] exception while creating category: $e');
      emit(AddCategoryFailure(e.toString()));
    }
  }
}
