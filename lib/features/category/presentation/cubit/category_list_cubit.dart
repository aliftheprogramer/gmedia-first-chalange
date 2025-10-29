import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final ScrollController controller = ScrollController();

  CategoryListCubit() : super(const CategoryListInitial());

  /// Scroll the horizontal list to the right by a fixed amount.
  void scrollRight({double amount = 150}) {
    if (controller.hasClients) {
      final double maxScroll = controller.position.maxScrollExtent;
      final double currentScroll = controller.offset;
      final double targetScroll = (currentScroll + amount).clamp(0, maxScroll);

      controller.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      emit(CategoryListState(targetScroll));
    }
  }

  @override
  Future<void> close() {
    try {
      controller.dispose();
    } catch (_) {}
    return super.close();
  }
}
