import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/domain/entity/entity_response_category.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_state.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';

class ListCategoryWidget extends StatelessWidget {
  final List<CategoryEntityResponse>? categories;

  const ListCategoryWidget({super.key, this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories != null) {
      return _CategoryListView(categories: categories!, selectedId: null);
    }

    try {
      final logger = sl<Logger>();
      return BlocProvider(
        create: (_) {
          logger.i('Creating CategoryCubit and fetching categories');
          final cubit = CategoryCubit(sl<GetAllCategoryUsecase>());
          cubit.fetchCategories();
          return cubit;
        },
        child: BlocListener<CategoryCubit, CategoryState>(
          listener: (context, state) {
            final logger = sl<Logger>();
            logger.d('CategoryState changed: $state');
            if (state is CategoryIsClicked) {
              logger.i('Selected category -> id: ${state.categoryId}, name: ${state.categoryName}');
              // Bisa trigger filter produk di sini
            }
          },
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const SizedBox(height: 56, child: Center(child: Text('Loading...')));
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
                return SizedBox(height: 56, child: Center(child: Text('Error: ${state.message}')));
              }

              return const SizedBox(height: 56);
            },
          ),
        ),
      );
    } catch (e, st) {
      try {
        sl<Logger>().e('Failed to initialize Category widget: $e\n$st');
      } catch (_) {}
      return const SizedBox(height: 56);
    }
  }
}

class _CategoryListView extends StatelessWidget {
  final List<CategoryEntityResponse> categories;
  final String? selectedId;

  const _CategoryListView({required this.categories, required this.selectedId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          // Akses cubit dari context (lebih aman & kompatibel)
          final cubit = context.read<CategoryCubit?>();

          return SizedBox(
            width: width,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              primary: false,
              shrinkWrap: true,
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
                  onTap: cubit == null
                      ? null
                      : () => cubit.selectCategory(category),
                );
              },
            ),
          );
        },
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
    final radius = BorderRadius.circular(20);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.10)
              : Colors.transparent,
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyMedium?.color,
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
    final radius = BorderRadius.circular(20);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.10)
              : Colors.transparent,
        ),
        child: Text(
          'Semua Menu',
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
