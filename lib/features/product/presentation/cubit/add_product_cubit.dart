import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/add_product_usecase.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
	final AddProductUsecase _addProductUsecase;

	AddProductCubit(this._addProductUsecase) : super(const AddProductInitial());

	Future<void> submit({
		required String categoryId,
		required String name,
		required String priceText,
		required String picturePath,
	}) async {
		// Basic validation
		if (categoryId.isEmpty) {
			emit(const AddProductFailure('Category ID tidak boleh kosong'));
			return;
		}
		if (name.isEmpty) {
			emit(const AddProductFailure('Nama produk tidak boleh kosong'));
			return;
		}
		final num? price = num.tryParse(priceText);
		if (price == null) {
			emit(const AddProductFailure('Harga tidak valid'));
			return;
		}
		if (picturePath.isEmpty) {
			emit(const AddProductFailure('Path gambar tidak boleh kosong'));
			return;
		}
		final file = File(picturePath);
		if (!await file.exists()) {
			emit(const AddProductFailure('File gambar tidak ditemukan'));
			return;
		}

		emit(const AddProductSubmitting());

		final request = ProductRequestEntity(
			categoryId: categoryId,
			name: name,
			price: price,
			picture: file,
		);

		try {
			final DataState<ProductEntityResponse> res =
					await _addProductUsecase.call(param: request);

			if (res is DataSuccess && res.data != null) {
				emit(AddProductSuccess(res.data!));
			} else if (res is DataFailed) {
				emit(AddProductFailure(res.error?.message ?? 'Gagal menambahkan produk'));
			} else {
				emit(const AddProductFailure('Gagal menambahkan produk'));
			}
		} catch (e) {
			emit(AddProductFailure(e.toString()));
		}
	}
}

