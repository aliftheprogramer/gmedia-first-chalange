import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/domain/repository/category_repository.dart';

class GetAllCategoryUsecase implements Usecase<DataState<List<CategoryEntityResponse>>, void> {
  final CategoryRepository repository;
  GetAllCategoryUsecase(this.repository);
  
  @override
  Future<DataState<List<CategoryEntityResponse>>> call({void param}) {
    return repository.getCategories();
  }
}