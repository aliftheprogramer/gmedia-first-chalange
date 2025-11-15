import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_form_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_state.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_success_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddCategoryCubit>(create: (_) => sl<AddCategoryCubit>()),
        BlocProvider<AddCategoryFormCubit>(create: (_) => AddCategoryFormCubit()),
      ],
      child: const _AddCategoryView(),
    );
  }
}

class _AddCategoryView extends StatefulWidget {
  const _AddCategoryView();

  @override
  State<_AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<_AddCategoryView> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori'),
      ),
      body: BlocConsumer<AddCategoryCubit, AddCategoryState>(
        listener: (context, state) {
          if (state is AddCategoryFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AddCategorySuccess) {
            if (mounted) setState(() => _showSuccess = true);
          }
        },
        builder: (context, state) {
          final formCubit = context.watch<AddCategoryFormCubit>();
          final formState = formCubit.state;
          final isSubmitting = state is AddCategorySubmitting;

          if (_showSuccess) {
            return SafeArea(
              child: CustomSuccessWidget(
                onBack: () {
                    try {
                      context.read<NavigationCubit>().updateIndex(0);
                    } catch (_) {}
                    Navigator.of(context).popUntil((route) => route.isFirst);
                },
                onAddAnother: () {
                    setState(() => _showSuccess = false);
                    try {
                      context.read<AddCategoryFormCubit>().reset();
                      context.read<AddCategoryCubit>().reset();
                    } catch (_) {}
                },
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isSubmitting) const LinearProgressIndicator(),
                if (isSubmitting) const SizedBox(height: 12),

                Text(
                  'Tambah Kategori',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

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
                        onChanged: formCubit.setName,
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
                        onPressed: (!isSubmitting && formState.name.trim().isNotEmpty)
                            ? () {
                                final addCubit = context.read<AddCategoryCubit>();
                                addCubit.submit(formState.name.trim());
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
            ),
          );
        },
      ),
    );
  }
}
