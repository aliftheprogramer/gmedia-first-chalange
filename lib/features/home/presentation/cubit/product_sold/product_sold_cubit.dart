import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sold/product_sold_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/search_product_query.dart';

class ProductSoldCubit extends Cubit<ProductSoldState>{
  final GetListProductUsecase _getListProductUsecase;
  List<ProductEntityResponse> _items = [];
  ProductSoldCubit(this._getListProductUsecase) : super(const ProductSoldInitial());

  Future<void> fetchSoldProducts() async {
    try {
      emit(const ProductSoldLoading());
      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(param: const GetListProductParams());

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.take(10).toList();
        if (_items.isEmpty) {
          emit(const ProductSoldEmpty());
        } else {
          emit(ProductSoldLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(ProductSoldError(res.error?.message ?? 'Failed to load sold products'));
      } else {
        emit(const ProductSoldEmpty());
      }
    } catch (e) {
      emit(ProductSoldError(e.toString()));
    }
  }
}