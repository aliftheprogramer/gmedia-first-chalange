class CategoryListState {
  final double offset;

  const CategoryListState(this.offset);
}

class CategoryListInitial extends CategoryListState {
  const CategoryListInitial([super.offset = 0]);
}
