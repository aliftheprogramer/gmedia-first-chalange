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

/// Bottom sheet content for adding a product. Stateless + managed by cubits.
class AddProductSheet extends StatelessWidget {
  const AddProductSheet({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final formCubit = context.read<AddProductFormCubit>();
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: false);
    if (result != null && result.files.isNotEmpty) {
      formCubit.setPickedPath(result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provide needed cubits locally.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddProductCubit(sl<AddProductUsecase>())),
        BlocProvider(create: (_) => AddProductFormCubit()),
        BlocProvider(create: (_) => CategoryCubit(sl<GetAllCategoryUsecase>())..fetchCategories()),
      ],
      child: Builder(
        builder: (innerCtx) {
          return BlocConsumer<AddProductCubit, AddProductState>(
            listener: (ctx, state) {
              if (state is AddProductFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is AddProductSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk berhasil ditambahkan')),
                );
                Navigator.of(context).pop(true); // close sheet
              }
            },
            builder: (ctx, submitState) {
              final isSubmitting = submitState is AddProductSubmitting;
              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    // ensure space for keyboard
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: BlocBuilder<AddProductFormCubit, AddProductFormState>(
                    builder: (context, form) {
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
                          Text('Tambah Produk', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 16),
                          if (isSubmitting) const LinearProgressIndicator(),
                          if (isSubmitting) const SizedBox(height: 12),
                          // Upload area with dashed border (custom painter simpler solution)
                          _DashedBorder(
                            child: InkWell(
                              onTap: () => _pickImage(context),
                              child: SizedBox(
                                height: 160,
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
                                    const Text(
                                      'Format Yang Didukung: Jpg & Png\nUkuran File Maximum 5Mb',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.2),
                                    ),
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
                                items = catState.categories.map((c) => DropdownMenuItem<String>(value: c.id, child: Text(c.name))).toList();
                              } else if (catState is CategoryIsClicked) {
                                items = catState.categories.map((c) => DropdownMenuItem<String>(value: c.id, child: Text(c.name))).toList();
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E63F9),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  child: (!isSubmitting)
                                      ? const Text('Tambah')
                                      : const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        ),
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

/// Simple dashed border container using CustomPainter to avoid extra dependency.
class _DashedBorder extends StatelessWidget {
  final Widget child;
  const _DashedBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(color: Colors.grey.shade400, strokeWidth: 1, gap: 6, dashLength: 6, radius: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;
  _DashedRectPainter({required this.color, required this.strokeWidth, required this.gap, required this.dashLength, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));

    // create path for dashed stroke
    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = dashLength;
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += len + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.radius != radius;
  }
}
