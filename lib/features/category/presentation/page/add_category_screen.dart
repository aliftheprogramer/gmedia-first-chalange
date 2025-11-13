import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_form_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_state.dart';

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

class _AddCategoryView extends StatelessWidget {
  const _AddCategoryView();

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kategori berhasil ditambahkan')),
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final formCubit = context.watch<AddCategoryFormCubit>();
          final formState = formCubit.state;
          final isSubmitting = state is AddCategorySubmitting;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Kategori',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: !isSubmitting,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nama kategori',
                  ),
                  onChanged: formCubit.setName,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (!isSubmitting && formState.name.trim().isNotEmpty)
                        ? () {
                            final addCubit = context.read<AddCategoryCubit>();
                            addCubit.submit(formState.name);
                          }
                        : null,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
