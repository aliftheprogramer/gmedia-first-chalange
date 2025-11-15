import 'package:dio/dio.dart';
import 'package:gmedia_project/core/constant/api_urls.dart';
import 'package:gmedia_project/core/network/dio_client.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/features/category/data/model/model_request_category.dart';
import 'package:gmedia_project/features/category/data/model/model_response_category.dart';

abstract class CategoryApiService {
  Future<DataState<List<CategoryResponseModel>>> fetchCategories();
  Future<DataState<void>> createCategory(
    CategoryRequestModel request,
  );
  Future<DataState<CategoryResponseModel>> updateCategory(
    CategoryRequestModel request,
  );
  Future<DataState<void>> deleteCategory(String id);
}

class CategoryApiServiceImpl implements CategoryApiService {
  final DioClient _dioClient = sl<DioClient>();

  @override
  Future<DataState<void>> createCategory(
    CategoryRequestModel request,
  ) async {
    try {
      // Log request attempt
      try {
        sl<Logger>().i('[CategoryApiService] createCategory request name=${request.name}');
      } catch (_) {}
      final formData = await request.toFormData();
      final response = await _dioClient.post(ApiUrls.category, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          sl<Logger>().i('[CategoryApiService] createCategory success status=${response.statusCode}');
        } catch (_) {}
        return DataSuccess(data: null);
      } else {
        try {
          sl<Logger>().w('[CategoryApiService] createCategory failed status=${response.statusCode}');
        } catch (_) {}
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to create category',
          ),
        );
      }
    } on DioException catch (e) {
      try {
        sl<Logger>().e('[CategoryApiService] createCategory exception: $e');
      } catch (_) {}
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteCategory(String id) async {
    try {
      final response = await _dioClient.delete('${ApiUrls.category}/$id');
      if (response.statusCode == 204) {
        return DataSuccess(data: null);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to delete category',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<CategoryResponseModel>>> fetchCategories() async {
    try {
      final response = await _dioClient.get(ApiUrls.category);
      if (response.statusCode == 200) {
        final categories = (response.data['data'] as List)
            .map((item) => CategoryResponseModel.fromJson(item))
            .toList();
        return DataSuccess(data: categories);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to fetch categories',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CategoryResponseModel>> updateCategory(
    CategoryRequestModel request,
  ) async{
    try {
      final formData = await request.toFormData();
      final response = await _dioClient.put(
        '${ApiUrls.categoryById}/${request.id}',
        data: formData,
      );

      if (response.statusCode == 200) {
        final updatedCategory = CategoryResponseModel.fromJson(response.data['data']);
        return DataSuccess(data: updatedCategory);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to update category',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
