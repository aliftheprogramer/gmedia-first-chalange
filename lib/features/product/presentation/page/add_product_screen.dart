import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_cubit.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_state.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/add_product_usecase.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_cubit.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_state.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_form_cubit.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_form_state.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final formCubit = context.read<AddProductFormCubit>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      formCubit.setPickedPath(result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddProductCubit(sl<AddProductUsecase>())),
        BlocProvider(create: (_) => AddProductFormCubit()),
        BlocProvider(create: (_) => CategoryCubit(sl<GetAllCategoryUsecase>())..fetchCategories()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Produk'),
        ),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AddProductSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produk berhasil ditambahkan')),
              );
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, submitState) {
            final isSubmitting = submitState is AddProductSubmitting;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<AddProductFormCubit, AddProductFormState>(
                builder: (context, form) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isSubmitting) const LinearProgressIndicator(),
                      if (isSubmitting) const SizedBox(height: 12),

                      // Upload area
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _pickImage(context),
                          child: Container(
                            height: 160,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_circle_outline, size: 28, color: Colors.blueAccent),
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: const [
                                    Text('Seret & Letakkan atau ', style: TextStyle(color: Colors.black87)),
                                    Text('Pilih File', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                                    Text(' untuk diunggah', style: TextStyle(color: Colors.black87)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text('Format Yang Didukung: Jpg & Png\nUkuran File Maximum 5Mb',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.2)),
                                const SizedBox(height: 12),
                                Container(height: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Text(
                                  form.pickedPath == null ? '-' : (form.pickedPath!.split('/').last),
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text('Nama Produk'),
                      const SizedBox(height: 6),
                      TextFormField(
                        onChanged: (v) => context.read<AddProductFormCubit>().setName(v.trim()),
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Sate',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Harga'),
                      const SizedBox(height: 6),
                      TextFormField(
                        onChanged: (v) => context.read<AddProductFormCubit>().setPriceText(v.trim()),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Rp',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text('Pilih Kategori'),
                      const SizedBox(height: 6),
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, catState) {
                          List<DropdownMenuItem<String>> items = [];
                          String? selected = form.selectedCategoryId;

                          if (catState is CategoryLoaded) {
                            items = catState.categories
                                .map((c) => DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(c.name),
                                    ))
                                .toList();
                          } else if (catState is CategoryIsClicked) {
                            items = catState.categories
                                .map((c) => DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(c.name),
                                    ))
                                .toList();
                            selected = catState.categoryId;
                          }

                          return DropdownButtonFormField<String>(
                            key: ValueKey(selected),
                            initialValue: selected,
                            items: items,
                            onChanged: (val) {
                              context.read<AddProductFormCubit>().setCategoryId(val);
                              if (val != null) {
                                final list = (catState is CategoryLoaded)
                                    ? catState.categories
                                    : (catState is CategoryIsClicked)
                                        ? catState.categories
                                        : [];
                                final c = list.firstWhere((e) => e.id == val);
                                context.read<CategoryCubit>().selectCategory(c);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Contoh: Makanan manis',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                              child: const Text('Batal'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      final formState = context.read<AddProductFormCubit>().state;
                                      context.read<AddProductCubit>().submit(
                                            categoryId: formState.selectedCategoryId ?? '',
                                            name: formState.name,
                                            priceText: formState.priceText,
                                            picturePath: formState.pickedPath ?? '',
                                          );
                                    },
                              child: const Text('Tambah'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}