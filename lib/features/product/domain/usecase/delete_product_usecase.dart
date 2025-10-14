import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class DeleteProductUsecase implements Usecase<DataState<void>, String?> {
  @override
  Future<DataState<void>> call({String? param}) async{
    return await sl<ProductRepository>().deleteProduct(param!);
  }
}