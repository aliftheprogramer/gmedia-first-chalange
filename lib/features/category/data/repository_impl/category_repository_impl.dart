import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/data/model/model_request_category.dart';
import 'package:gmedia_project/features/category/data/source/category_api_service.dart';

import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository{
  final CategoryApiService _categoryApiService = sl<CategoryApiService>();
  final _log = sl<Logger>();
  @override
  Future<DataState<void>> createCategory(EntityRequestCategory category) async {
    final requestModel = CategoryRequestModel(name: category.name);
    try {
      _log.i('[CategoryRepository] createCategory name=${category.name}');
    } catch (_) {}
    final httpResponse = await _categoryApiService.createCategory(requestModel);
    if (httpResponse is DataSuccess) {
      try {
        _log.i('[CategoryRepository] createCategory success');
      } catch (_) {}
      return DataSuccess(data: null);
    }
    try {
      _log.w('[CategoryRepository] createCategory failed ${httpResponse.error}');
    } catch (_) {}
    return DataFailed(httpResponse.error!);
  }

  @override
  Future<DataState<void>> deleteCategory(String id) async {
    final httpResponse = await _categoryApiService.deleteCategory(id);
    if (httpResponse is DataSuccess) {
      return DataSuccess(data: null);
    }
    return DataFailed(httpResponse.error!);
  }

  @override
  Future<DataState<List<CategoryEntityResponse>>> getCategories() async {
    final httpResponse = await _categoryApiService.fetchCategories();
    if (httpResponse is DataSuccess && httpResponse.data != null) {
      return DataSuccess(data: httpResponse.data!.map((e) => e.toEntity()).toList());
    }
    return DataFailed(httpResponse.error!);
  }

  

  @override
  Future<DataState<CategoryEntityResponse>> updateCategory(EntityRequestCategory category) async {
    final requestModel = CategoryRequestModel(name: category.name);
    final httpResponse = await _categoryApiService.updateCategory(requestModel);
    if (httpResponse is DataSuccess && httpResponse.data != null) {
      return DataSuccess(data: httpResponse.data!.toEntity());
    }
    return DataFailed(httpResponse.error!);
  }
  
  @override
  Future<DataState<CategoryEntityResponse>> getCategoryById(String id) {
    throw UnimplementedError();
  }
}