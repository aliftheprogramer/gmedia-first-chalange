class CategoryEntityResponse {
	final String id;
	final String name;
	final DateTime? createdAt;

	CategoryEntityResponse({
		required this.id,
		required this.name,
		this.createdAt,
	});

	factory CategoryEntityResponse.fromJson(Map<String, dynamic> json) {
		return CategoryEntityResponse(
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

	@override
	String toString() => 'CategoryEntityResponse(id: $id, name: $name, createdAt: $createdAt)';
}
