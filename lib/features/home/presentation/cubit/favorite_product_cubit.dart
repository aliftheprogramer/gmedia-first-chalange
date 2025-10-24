import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/home/presentation/cubit/favorite_product_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/search_product_query.dart';

class FavoriteProductCubit extends Cubit<FavoriteProductState> {
  final GetListProductUsecase _getListProductUsecase;
  // keep local cache
  List<ProductEntityResponse> _items = [];

  FavoriteProductCubit(this._getListProductUsecase) : super(const FavoriteProductInitial());

  Future<void> fetchFavorites() async {
    try {
      emit(const FavoriteProductLoading());

      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(param: const GetListProductParams());

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        // keep maximum 5
        _items = list.take(5).toList();
        if (_items.isEmpty) {
          emit(const FavoriteProductEmpty());
        } else {
          emit(FavoriteProductLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(FavoriteProductError(res.error?.message ?? 'Failed to load favorites'));
      } else {
        emit(const FavoriteProductEmpty());
      }
    } catch (e) {
      emit(FavoriteProductError(e.toString()));
    }
  }

  void addFavorite(ProductEntityResponse product) {
    _items.insert(0, product);
    if (_items.length > 5) _items = _items.take(5).toList();
    emit(FavoriteProductAdded(product));
    emit(FavoriteProductLoaded(_items));
  }

  void removeFavorite(ProductEntityResponse product) {
    _items.removeWhere((p) => p.id == product.id);
    emit(FavoriteProductRemoved(product));
    if (_items.isEmpty) {
      emit(const FavoriteProductEmpty());
    } else {
      emit(FavoriteProductLoaded(_items));
    }
  }
}
