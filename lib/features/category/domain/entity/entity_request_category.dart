class EntityRequestCategory {
  final String? id;
  final String name;
  EntityRequestCategory({this.id, required this.name});

  factory EntityRequestCategory.fromJson(Map<String, dynamic> json) {
    return EntityRequestCategory(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => 'EntityRequestCategory(id: $id, name: $name)';
}
