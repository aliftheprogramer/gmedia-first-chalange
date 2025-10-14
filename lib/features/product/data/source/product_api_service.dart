import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/data/model/product_model_response.dart';

abstract class ProductApiService {
  Future<DataState<List<ProductResponseModel>>> getProducts(String? param);
}