import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';

abstract class ProductRepository {
  Future<DataState<List<ProductEntityResponse>>> getProducts(String? categoryId, String? searchParam);
  Future<DataState<ProductEntityResponse>> getProductById(String id);
  Future<DataState<ProductEntityResponse>> createProduct(ProductRequestEntity request);
  Future<DataState<ProductEntityResponse>> updateProduct(String id, ProductRequestEntity request);
  Future<DataState<void>> deleteProduct(String id);
}