import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/data/source/category_api_service.dart';

import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository{
  final CategoryApiService _categoryApiService = sl<CategoryApiService>();
  @override
  Future<DataState<CategoryEntityResponse>> createCategory(EntityRequestCategory category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<CategoryEntityResponse>>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<DataState<CategoryEntityResponse>> getCategoryById(String id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<DataState<CategoryEntityResponse>> updateCategory(EntityRequestCategory category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}