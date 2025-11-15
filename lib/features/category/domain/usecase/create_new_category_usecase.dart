import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';
import 'package:gmedia_project/features/category/domain/repository/category_repository.dart';

class CreateNewCategoryUsecase implements Usecase<DataState<void>, String> {
  final CategoryRepository repository;

  CreateNewCategoryUsecase(this.repository);

  @override
  Future<DataState<void>> call({String? param}) {
    if (param == null || param.isEmpty) {
      throw ArgumentError('Category name is required');
    }
    final request = EntityRequestCategory(name: param);
    return repository.createCategory(request);
  }
}