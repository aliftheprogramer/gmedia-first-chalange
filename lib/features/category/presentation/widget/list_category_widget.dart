import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_list_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_state.dart';

class ListCategoryWidget extends StatelessWidget {
  final List<CategoryEntityResponse>? categories;

  const ListCategoryWidget({super.key, this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories != null) {
      return _CategoryListView(categories: categories!, selectedId: null);
    }

    // Expect a CategoryCubit to be provided by an ancestor (e.g., the screen).
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SizedBox(height: 32, child: Center(child: Text('Loading...')));
        }

        if (state is CategoryLoaded) {
          return _CategoryListView(
            categories: state.categories,
            selectedId: state.selectedId,
          );
        }

        if (state is CategoryIsClicked) {
          return _CategoryListView(
            categories: state.categories,
            selectedId: state.categoryId,
          );
        }

        if (state is CategoryError) {
          return SizedBox(height: 32, child: Center(child: Text('Error: ${state.message}')));
        }

        return const SizedBox(height: 32);
      },
    );
  }
}

class _CategoryListView extends StatelessWidget {
  final List<CategoryEntityResponse> categories;
  final String? selectedId;

  const _CategoryListView({required this.categories, required this.selectedId});

  @override
  Widget build(BuildContext context) {
    // Provide a local cubit that owns the ScrollController and scroll behaviour.
    return BlocProvider(
      create: (_) => CategoryListCubit(),
      child: _CategoryListViewContent(categories: categories, selectedId: selectedId),
    );
  }
}

class _CategoryListViewContent extends StatelessWidget {
  final List<CategoryEntityResponse> categories;
  final String? selectedId;

  const _CategoryListViewContent({required this.categories, required this.selectedId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryCubit?>();
    final listCubit = context.read<CategoryListCubit>();

    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              controller: listCubit.controller,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final bool isSelected = selectedId == null;
                  return _AllCategoryItem(
                    selected: isSelected,
                    onTap: cubit == null ? null : () => cubit.clearSelection(),
                  );
                }

                final category = categories[index - 1];
                final isSelected = selectedId != null && category.id == selectedId;

                return CategoryItemWidget(
                  category: category,
                  selected: isSelected,
                  onTap: cubit == null ? null : () => cubit.selectCategory(category),
                );
              },
            ),
          ),

          // Tombol '>'
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => listCubit.scrollRight(),
            child: Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF1843C3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final CategoryEntityResponse category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryItemWidget({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? const Color(0xFFD6DFFA) : Colors.transparent;
    final textColor = selected ? const Color(0xFF1843C3) : const Color(0xFF7A7A7A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          category.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AllCategoryItem extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;

  const _AllCategoryItem({this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? const Color(0xFFD6DFFA) : Colors.transparent;
    final textColor = selected ? const Color(0xFF1843C3) : const Color(0xFF7A7A7A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Semua Menu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
