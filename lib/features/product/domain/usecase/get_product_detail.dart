import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class GetProductDetail
    implements Usecase<DataState<ProductEntityResponse>, String?> {
      final ProductRepository _repository;
      GetProductDetail(this._repository);
  
  @override
  Future<DataState<ProductEntityResponse>> call({String? param}) {
    return _repository.getProductById(param!);
  }
}
