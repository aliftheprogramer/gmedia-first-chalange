import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/data/model/product_model_request.dart';
import 'package:gmedia_project/features/product/data/model/product_model_response.dart';

abstract class ProductApiService {
  Future<DataState<List<ProductResponseModel>>> getProducts(String? param);
  Future<DataState<ProductResponseModel>> getProductById(String id);
  Future<DataState<ProductResponseModel>> createProduct(ProductRequestModel product);
  Future<DataState<ProductResponseModel>> updateProduct(String id, ProductRequestModel product);
  Future<DataState<void>> deleteProduct(String id);
  }

  class ProductApiServiceImpl implements ProductApiService{
  @override
  Future<DataState<ProductResponseModel>> createProduct(ProductRequestModel product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }
  
  @override
  Future<DataState<void>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }
  
  @override
  Future<DataState<ProductResponseModel>> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }
  
  @override
  Future<DataState<List<ProductResponseModel>>> getProducts(String? param) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
  
  @override
  Future<DataState<ProductResponseModel>> updateProduct(String id, ProductRequestModel product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
  }