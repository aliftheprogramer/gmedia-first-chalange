import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/edit_product_param.dart';

class EditProductUsecase implements Usecase<DataState<ProductEntityResponse>, EditProductParams> {
  final ProductRepository _productRepository;

  EditProductUsecase(this._productRepository);

  @override
  Future<DataState<ProductEntityResponse>> call({EditProductParams? param}) async {
    if (param == null) {
      throw ArgumentError("Parameter untuk edit produk tidak boleh kosong.");
    }
    return await _productRepository.updateProduct(param.id, param.request);
  }
}