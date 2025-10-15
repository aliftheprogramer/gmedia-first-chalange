import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class AddProductUsecase implements Usecase<DataState<ProductEntityResponse>, ProductRequestEntity> {
  final ProductRepository _repository;

  AddProductUsecase(this._repository);

  @override
  Future<DataState<ProductEntityResponse>> call({ProductRequestEntity? param}) async {
    return await _repository.createProduct(param!);
  }
}

