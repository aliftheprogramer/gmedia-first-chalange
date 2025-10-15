import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';
import 'package:gmedia_project/features/product/domain/usecase/search_product_query.dart';


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