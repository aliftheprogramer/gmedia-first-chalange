// lib/features/product/data/repository_impl/product_repository_impl.dart


import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/product/data/model/product_model_request.dart';
import 'package:gmedia_project/features/product/data/source/product_api_service.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/search_product_query.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _productApiService = sl<ProductApiService>();

  @override
  Future<DataState<List<ProductEntityResponse>>> getProducts(GetListProductParams? params) async {
    final httpResponse = await _productApiService.getProducts(params);

    if (httpResponse is DataSuccess && httpResponse.data != null) {
      final entities = httpResponse.data!.map((model) => model.toEntity()).toList();
      return DataSuccess(data: entities);
    }
    
    return DataFailed(httpResponse.error!);
  }
  @override
  Future<DataState<ProductEntityResponse>> getProductById(String id) async {
    final httpResponse = await _productApiService.getProductById(id);

    if (httpResponse is DataSuccess && httpResponse.data != null) {
      return DataSuccess(data: httpResponse.data!.toEntity());
    }

    return DataFailed(httpResponse.error!);
  }

  @override
  Future<DataState<ProductEntityResponse>> createProduct(ProductRequestEntity request) async {
    // Buat model dari entity
    final requestModel = ProductRequestModel(
      categoryId: request.categoryId,
      name: request.name,
      price: request.price,
      picture: request.picture,
    );

    final httpResponse = await _productApiService.createProduct(requestModel);

    if (httpResponse is DataSuccess && httpResponse.data != null) {
      return DataSuccess(data: httpResponse.data!.toEntity());
    }

    return DataFailed(httpResponse.error!);
  }

  @override
  Future<DataState<ProductEntityResponse>> updateProduct(String id, ProductRequestEntity request) async {
    final requestModel = ProductRequestModel(
      categoryId: request.categoryId,
      name: request.name,
      price: request.price,
      picture: request.picture,
    );

    final httpResponse = await _productApiService.updateProduct(id, requestModel);

    if (httpResponse is DataSuccess && httpResponse.data != null) {
      return DataSuccess(data: httpResponse.data!.toEntity());
    }

    return DataFailed(httpResponse.error!);
  }

  @override
  Future<DataState<void>> deleteProduct(String id) async {
    return await _productApiService.deleteProduct(id);
  }
}