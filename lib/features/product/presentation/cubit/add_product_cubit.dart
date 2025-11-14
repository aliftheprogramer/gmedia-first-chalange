import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:gmedia_project/core/resources/data_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_request.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/add_product_usecase.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_state.dart';
import 'package:logger/logger.dart';

class AddProductCubit extends Cubit<AddProductState> {
	final AddProductUsecase _addProductUsecase;
  final Logger _log = Logger();

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
			_log.i('[AddProductCubit] Validation failed: categoryId empty');
			emit(const AddProductFailure('Category ID tidak boleh kosong'));
			return;
		}
		if (name.isEmpty) {
			_log.i('[AddProductCubit] Validation failed: name empty');
			emit(const AddProductFailure('Nama produk tidak boleh kosong'));
			return;
		}
		final num? price = num.tryParse(priceText);
		if (price == null) {
			_log.i('[AddProductCubit] Validation failed: price invalid ($priceText)');
			emit(const AddProductFailure('Harga tidak valid'));
			return;
		}
		if ((picturePath == null || picturePath.isEmpty) && (pictureBytes == null || pictureBytes.isEmpty)) {
			_log.i('[AddProductCubit] Validation failed: picture missing');
			emit(const AddProductFailure('Gambar tidak boleh kosong'));
			return;
		}
		if (pictureFilename == null || pictureFilename.isEmpty) {
			_log.i('[AddProductCubit] Validation failed: pictureFilename missing');
			emit(const AddProductFailure('Nama file tidak tersedia'));
			return;
		}

		_log.i('[AddProductCubit] Submitting product...');
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
			final DataState<ProductEntityResponse> res = await _addProductUsecase.call(param: request);
			_log.i('[AddProductCubit] Submit response type=${res.runtimeType} data=${res.data} error=${res.error}');
			if (res is DataSuccess) {
				// Normalize various possible data shapes into domain entity
				final dynamic raw = res.data;
				ProductEntityResponse product;
				if (raw is ProductEntityResponse) {
					product = raw;
				} else if (raw is Map) {
					final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
					final dynamic priceRaw = map['price'];
					int priceInt;
					if (priceRaw is int) {
						priceInt = priceRaw;
					} else if (priceRaw is num) {
						priceInt = priceRaw.toInt();
					} else if (priceRaw is String) {
						priceInt = int.tryParse(priceRaw) ?? (price is int ? price : price.toInt());
					} else {
						priceInt = (price is int ? price : price.toInt());
					}
					product = ProductEntityResponse(
						id: (map['id'] ?? '').toString(),
						categoryId: (map['category_id'] ?? categoryId).toString(),
						name: (map['name'] ?? name).toString(),
						price: priceInt,
						pictureUrl: (map['picture_url'] ?? '').toString(),
					);
				} else {
					// Fallback if backend returns no or unexpected body
					product = ProductEntityResponse(
						id: DateTime.now().millisecondsSinceEpoch.toString(),
						categoryId: categoryId,
						name: name,
						price: price is int ? price : price.toInt(),
						pictureUrl: '',
					);
				}
				_log.i('[AddProductCubit] Emitting success for product id=${product.id}');
				emit(AddProductSuccess(product));
			} else if (res is DataFailed) {
				_log.i('[AddProductCubit] Submit failed: ${res.error}');
				emit(AddProductFailure(res.error?.message ?? 'Gagal menambahkan produk'));
			} else {
				_log.i('[AddProductCubit] Unknown response state, treating as failure');
				emit(const AddProductFailure('Gagal menambahkan produk'));
			}
		} catch (e) {
			_log.i('[AddProductCubit] Exception: $e');
			emit(AddProductFailure(e.toString()));
		}
	}
}

