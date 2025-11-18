class GetListProductParams {
  final String? categoryId;
  final String? search;

  const GetListProductParams({this.categoryId, this.search});

  Map<String, dynamic> toJson() {
    return {
      // server expects snake_case key
      'category_id': categoryId,
      'search': search,
    };
  }
}
