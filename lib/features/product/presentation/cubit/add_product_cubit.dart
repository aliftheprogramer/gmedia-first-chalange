import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
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
		String? picturePath,
		Uint8List? pictureBytes,
		String? pictureFilename,
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
		if ((picturePath == null || picturePath.isEmpty) && (pictureBytes == null || pictureBytes.isEmpty)) {
			emit(const AddProductFailure('Gambar tidak boleh kosong'));
			return;
		}
		if (pictureFilename == null || pictureFilename.isEmpty) {
			emit(const AddProductFailure('Nama file tidak tersedia'));
			return;
		}

		emit(const AddProductSubmitting());

		final request = ProductRequestEntity(
			categoryId: categoryId,
			name: name,
			price: price,
			pictureFilename: pictureFilename,
			picturePath: picturePath,
			pictureBytes: pictureBytes,
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

