import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/param/search_product_query.dart';

class ProductSellCubit extends Cubit<ProductSellState> {
  final GetListProductUsecase _getListProductUsecase;
  List<ProductEntityResponse> _items = [];
  // cache all fetched products for client-side filtering
  List<ProductEntityResponse> _allItems = [];
  ProductSellCubit(this._getListProductUsecase)
    : super(const ProductSellInitial());

  Future<void> fetchSoldProducts() async {
    try {
      emit(const ProductSellLoading());
      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(
            param: const GetListProductParams(),
          );

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.take(4).toList();
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(
          ProductSellError(
            res.error?.message ?? 'Failed to load sold products',
          ),
        );
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
          await _getListProductUsecase.call(
            param: const GetListProductParams(),
          );

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.toList();
        // also populate cache when fetching all
        _allItems = _items.toList();
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(
          ProductSellError(
            res.error?.message ?? 'Failed to load sold products',
          ),
        );
      } else {
        emit(const ProductSellEmpty());
      }
    } catch (e) {
      emit(ProductSellError(e.toString()));
    }
  }

  /// Generic filter by [categoryId] and/or [search] query.
  Future<void> fetchByFilter({String? categoryId, String? search}) async {
    final logger = sl<Logger>();
    try {
      logger.i(
        'fetchByFilter called, categoryId: $categoryId, search: $search',
      );
      // If we have cached full list, filter client-side (backend may not support filter)
      if (_allItems.isNotEmpty) {
        final filtered = _allItems.where((p) {
          final matchCategory =
              categoryId == null || p.categoryId == categoryId;
          final matchSearch = search == null || search.isEmpty
              ? true
              : p.name.toLowerCase().contains(search.toLowerCase());
          return matchCategory && matchSearch;
        }).toList();

        _items = filtered;
        logger.i('fetchByFilter (client) result count: ${_items.length}');
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
        return;
      }

      // Fallback: request server-side filter (if supported)
      emit(const ProductSellLoading());
      final res = await _getListProductUsecase.call(
        param: GetListProductParams(categoryId: categoryId, search: search),
      );

      if (res is DataSuccess && res.data != null) {
        _items = res.data!;
        logger.i('fetchByFilter result count: ${_items.length}');
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        logger.e('fetchByFilter failed: ${res.error}');
        emit(ProductSellError(res.error?.message ?? 'Failed to load products'));
      } else {
        logger.w('fetchByFilter returned empty');
        emit(const ProductSellEmpty());
      }
    } catch (e, st) {
      logger.e('fetchByFilter exception: $e\n$st');
      emit(ProductSellError(e.toString()));
    }
  }

  /// Fetch products filtered by a specific category. If [categoryId] is null,
  /// fetch all products.
  Future<void> fetchByCategory(String? categoryId) async {
    try {
      emit(const ProductSellLoading());
      final DataState<List<ProductEntityResponse>> res =
          await _getListProductUsecase.call(
            param: GetListProductParams(categoryId: categoryId),
          );

      if (res is DataSuccess && res.data != null) {
        final list = res.data!;
        _items = list.toList();
        if (_items.isEmpty) {
          emit(const ProductSellEmpty());
        } else {
          emit(ProductSellLoaded(_items));
        }
      } else if (res is DataFailed) {
        emit(ProductSellError(res.error?.message ?? 'Failed to load products'));
      } else {
        emit(const ProductSellEmpty());
      }
    } catch (e) {
      emit(ProductSellError(e.toString()));
    }
  }
}
