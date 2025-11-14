import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_form_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_form_state.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_state.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_success_widget.dart';

/// Bottom sheet for adding a category with the same overlay success UX as AddProductSheet.
class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddCategoryCubit>(create: (_) => sl<AddCategoryCubit>()),
        BlocProvider<AddCategoryFormCubit>(create: (_) => AddCategoryFormCubit()),
      ],
      child: Builder(
        builder: (innerCtx) {
          return BlocConsumer<AddCategoryCubit, AddCategoryState>(
            listener: (ctx, state) {
              if (state is AddCategoryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is AddCategorySuccess) {
                if (mounted) {
                  // Hanya ganti konten sheet ke widget sukses (tanpa overlay tambahan)
                  setState(() => _showSuccess = true);
                }
              }
            },
            builder: (ctx, state) {
              final isSubmitting = state is AddCategorySubmitting;
              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: _showSuccess
                      ? CustomSuccessWidget(
                          onBack: () {
                            Navigator.of(context).pop();
                            try {
                              context.read<NavigationCubit>().updateIndex(0);
                            } catch (_) {}
                          },
                          onAddAnother: () {
                            setState(() => _showSuccess = false);
                            try {
                              context.read<AddCategoryFormCubit>().reset();
                              context.read<AddCategoryCubit>().reset();
                            } catch (_) {}
                          },
                        )
                      : BlocBuilder<AddCategoryFormCubit, AddCategoryFormState>(
                          builder: (context, form) {
                            final canSubmit = !isSubmitting && form.name.trim().isNotEmpty;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // drag handle
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Tambah Kategori',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 16),
                                if (isSubmitting) const LinearProgressIndicator(),
                                if (isSubmitting) const SizedBox(height: 12),

                                // Card-style container for the single field
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        enabled: !isSubmitting,
                                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Cth: Makanan manis'),
                                        onChanged: context.read<AddCategoryFormCubit>().setName,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF1E63F9),
                                          side: const BorderSide(color: Color(0xFF1E63F9), width: 1),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          textStyle: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        child: const Text('Batal'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: canSubmit
                                            ? () {
                                                final name = context.read<AddCategoryFormCubit>().state.name.trim();
                                                context.read<AddCategoryCubit>().submit(name);
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1E63F9),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        child: isSubmitting
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : const Text('Tambah'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
