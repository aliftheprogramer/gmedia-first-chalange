import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategoryUsecase _getAllCategoryUsecase;

  CategoryCubit(this._getAllCategoryUsecase) : super(const CategoryInitial());

  // cache data & selection
  List<CategoryEntityResponse> _categories = [];
  String? selectedId;
  String? selectedName;

  Future<void> fetchCategories() async {
    try {
      emit(const CategoryLoading());
      final res = await _getAllCategoryUsecase.call();
      if (res is DataSuccess && res.data != null) {
        _categories = res.data!;
        emit(CategoryLoaded(_categories, selectedId: selectedId, selectedName: selectedName));
      } else if (res is DataFailed) {
        emit(CategoryError(res.error?.message ?? 'Failed to load categories'));
      } else {
        _categories = [];
        emit(const CategoryLoaded([]));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// Simpan id & name dari category terpilih dan emisi state klik.
  void selectCategory(CategoryEntityResponse category) {
    selectedId = category.id;
    selectedName = category.name;

    emit(CategoryIsClicked(
      categories: _categories,
      categoryId: selectedId!,
      categoryName: selectedName!,
    ));
  }

  /// Opsional: hapus pilihan
  void clearSelection() {
    selectedId = null;
    selectedName = null;
    emit(CategoryLoaded(_categories));
  }
}
