import 'package:equatable/equatable.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// State utama saat data tersedia. Bisa sekaligus menyimpan pilihan aktif (opsional).
class CategoryLoaded extends CategoryState {
  final List<CategoryEntityResponse> categories;
  final String? selectedId;
  final String? selectedName;

  const CategoryLoaded(this.categories, {this.selectedId, this.selectedName});

  @override
  List<Object?> get props => [categories, selectedId, selectedName];
}


class CategoryIsClicked extends CategoryState {
  final List<CategoryEntityResponse> categories;
  final String categoryId;
  final String categoryName;

  const CategoryIsClicked({
    required this.categories,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [categories, categoryId, categoryName];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
