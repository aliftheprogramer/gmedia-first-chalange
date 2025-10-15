import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';

class DeleteProductUsecase implements Usecase<DataState<void>, String?> {
  final ProductRepository _repository;
  DeleteProductUsecase(this._repository);
  
  @override
  Future<DataState<void>> call({String? param}) async {
    return await _repository.deleteProduct(param!);
  }
}