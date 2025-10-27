import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';

class CategoryResponseModel extends CategoryEntityResponse {
	CategoryResponseModel({
		required super.id,
		required super.name,
		super.createdAt,
	});

	factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
		return CategoryResponseModel(
			id: json['id'] as String? ?? '',
			name: json['name'] as String? ?? '',
			createdAt: json['created_at'] != null
					? DateTime.tryParse(json['created_at'] as String)
					: null,
		);
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'created_at': createdAt?.toIso8601String(),
			};

	CategoryEntityResponse toEntity() => CategoryEntityResponse(
				id: id,
				name: name,
				createdAt: createdAt,
			);
}
