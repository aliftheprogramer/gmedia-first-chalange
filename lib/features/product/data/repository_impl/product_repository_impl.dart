// lib/features/product/data/repository_impl/product_repository_impl.dart

import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<DataState<ProductEntityResponse>> createProduct(ProductRequestEntity request) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<DataState<ProductEntityResponse>> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<ProductEntityResponse>>> getProducts(GetListProductParams? params) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Future<DataState<ProductEntityResponse>> updateProduct(String id, ProductRequestEntity request) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}