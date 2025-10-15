class GetListProductParams {
  final String? categoryId;
  final String? search;

  const GetListProductParams({this.categoryId, this.search});

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'search': search,
    };
  }
}
