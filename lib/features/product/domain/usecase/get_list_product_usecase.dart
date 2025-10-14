import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class  GetListProductUsecase implements Usecase<DataState<List<ProductEntityResponse>>, String> {
   GetListProductUsecase(ProductRepository repository);
  @override
  Future<DataState<List<ProductEntityResponse>>> call({String? param}) {
    return sl<ProductRepository>().getProducts();
  }
  
}