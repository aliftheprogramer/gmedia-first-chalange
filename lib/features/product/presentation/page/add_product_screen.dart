import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/product/domain/usecase/add_product_usecase.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_cubit.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_state.dart';


class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _picturePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddProductCubit(sl<AddProductUsecase>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
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
              // Kembali ke halaman sebelumnya setelah sukses
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            final isSubmitting = state is AddProductSubmitting;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isSubmitting) const LinearProgressIndicator(),
                  if (isSubmitting) const SizedBox(height: 12),
                  TextField(
                    controller: _categoryIdController,
                    decoration: const InputDecoration(
                      labelText: 'Category ID',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _picturePathController,
                    decoration: const InputDecoration(
                      labelText: 'Picture Path',
                      hintText: '/path/to/image.jpg',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            context.read<AddProductCubit>().submit(
                                  categoryId: _categoryIdController.text.trim(),
                                  name: _nameController.text.trim(),
                                  priceText: _priceController.text.trim(),
                                  picturePath: _picturePathController.text.trim(),
                                );
                          },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}