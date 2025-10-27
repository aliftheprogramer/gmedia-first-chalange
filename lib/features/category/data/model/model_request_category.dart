import 'package:gmedia_project/features/category/domain/entity/entity_request_category.dart';

class CategoryRequestModel extends EntityRequestCategory {
	CategoryRequestModel({super.id, required super.name});

	factory CategoryRequestModel.fromJson(Map<String, dynamic> json) {
		return CategoryRequestModel(
			id: json['id'] as String?,
			name: json['name'] as String? ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
				if (id != null) 'id': id,
				'name': name,
			};

	EntityRequestCategory toEntity() => EntityRequestCategory(id: id, name: name);
}
