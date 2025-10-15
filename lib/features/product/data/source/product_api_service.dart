// lib/features/product/data/datasources/product_api_service.dart

import 'package:dio/dio.dart';
import 'package:gmedia_project/core/constant/api_urls.dart';
import 'package:gmedia_project/core/network/dio_client.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/product/data/model/product_model_request.dart';
import 'package:gmedia_project/features/product/data/model/product_model_response.dart';

abstract class ProductApiService {
  Future<DataState<List<ProductResponseModel>>> getProducts();
  Future<DataState<ProductResponseModel>> getProductById(String id);
  Future<DataState<ProductResponseModel>> createProduct(ProductRequestModel product);
  Future<DataState<ProductResponseModel>> updateProduct(String id, ProductRequestModel product);
  Future<DataState<void>> deleteProduct(String id);
}

class ProductApiServiceImpl implements ProductApiService {
  final DioClient _dioClient = sl<DioClient>();

  @override
  Future<DataState<List<ProductResponseModel>>> getProducts() async {
    try {
      final response = await _dioClient.get(ApiUrls.product);

      if (response.statusCode == 200) {

        final List<dynamic> productListJson = response.data['data'];

        final List<ProductResponseModel> products = productListJson
            .map((productJson) => ProductResponseModel.fromJson(productJson as Map<String, dynamic>))
            .toList();
      
        return DataSuccess(data: products);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to load products',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<ProductResponseModel>> getProductById(String id) async {
    try {
      final response = await _dioClient.get('${ApiUrls.product}/$id');

      if (response.statusCode == 200) {
        final product = ProductResponseModel.fromJson(response.data['data']);
        return DataSuccess(data: product);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to load product',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<ProductResponseModel>> createProduct(ProductRequestModel product) async {
    try {
      final formData = await product.toFormData();
      final response = await _dioClient.post(
        ApiUrls.product,
        data: formData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final newProduct = ProductResponseModel.fromJson(response.data['data']);
        return DataSuccess(data: newProduct);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to create product',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<ProductResponseModel>> updateProduct(String id, ProductRequestModel product) async {
    try {
      final formData = await product.toFormData();
      
      final response = await _dioClient.post(
        '${ApiUrls.productById}/$id', 
        data: formData,
      );

      if (response.statusCode == 200) {
        final updatedProduct = ProductResponseModel.fromJson(response.data['data']);
        return DataSuccess(data: updatedProduct);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to update product',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteProduct(String id) async {
    try {
      final response = await _dioClient.delete('${ApiUrls.product}/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const DataSuccess(data: null);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to delete product',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}