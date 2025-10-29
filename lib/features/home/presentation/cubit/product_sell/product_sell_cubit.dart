import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/search_product_query.dart';

class ProductSellCubit extends Cubit<ProductSellState>{
  final GetListProductUsecase _getListProductUsecase;
  List<ProductEntityResponse> _items = [];
  ProductSellCubit(this._getListProductUsecase) : super(const ProductSellInitial());

  Future<void> fetchSoldProducts() async {
    try {
      emit(const ProductSellLoading());
      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(param: const GetListProductParams());

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.take(4).toList();
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(ProductSellError(res.error?.message ?? 'Failed to load sold products'));
      } else {
        emit(const ProductSellEmpty());
      }
    } catch (e) {
      emit(ProductSellError(e.toString()));
    }
  }
    Future<void> fetchSoldProductsAll() async {
    try {
      emit(const ProductSellLoading());
      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(param: const GetListProductParams());

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.toList();
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(ProductSellError(res.error?.message ?? 'Failed to load sold products'));
      } else {
        emit(const ProductSellEmpty());
      }
    } catch (e) {
      emit(ProductSellError(e.toString()));
    }
  }
}