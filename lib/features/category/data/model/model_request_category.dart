import 'package:dio/dio.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';

class CategoryRequestModel extends EntityRequestCategory {
	CategoryRequestModel({String? id, required String name}) : super(id: id, name: name);

	factory CategoryRequestModel.fromJson(Map<String, dynamic> json) {
		return CategoryRequestModel(
			id: json['id'] as String?,
			name: json['name'] as String? ?? '',
		);
	}

	Map<String, dynamic> toJson() {
		return {
			if (id != null) 'id': id,
			'name': name,
		};
	}

	Future<FormData> toFormData() async {
		final formDataMap = <String, dynamic>{
			if (id != null) 'id': id,
			'name': name,
		};
		return FormData.fromMap(formDataMap);
	}

	EntityRequestCategory toEntity() => EntityRequestCategory(id: id, name: name);

	@override
	String toString() => 'CategoryRequestModel(id: $id, name: $name)';
}
