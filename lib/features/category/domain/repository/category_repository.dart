import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';

abstract class CategoryRepository {
  Future<DataState<List<CategoryEntityResponse>>> getCategories();
  Future<DataState<CategoryEntityResponse>> createCategory(EntityRequestCategory category);
  Future<DataState<CategoryEntityResponse>> updateCategory(EntityRequestCategory category);
  Future<DataState<void>> deleteCategory(String id);
  Future<DataState<CategoryEntityResponse>> getCategoryById(String id);
}