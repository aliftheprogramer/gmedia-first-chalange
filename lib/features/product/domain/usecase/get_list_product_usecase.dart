import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class GetListProductParams {
  final String? categoryId;
  final String? search;

  const GetListProductParams({this.categoryId, this.search});
}

class GetListProductUsecase
    implements
        Usecase<DataState<List<ProductEntityResponse>>, GetListProductParams> {
  final ProductRepository repository;

  GetListProductUsecase(this.repository);

  @override
  Future<DataState<List<ProductEntityResponse>>> call(
      {GetListProductParams? param}) {
    return repository.getProducts(param);
  }
}