import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show File, Directory; // only used on non-web platforms
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_success_widget.dart';

/// Bottom sheet content for adding a product. Now swaps to a success widget on submit.
class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  bool _showSuccess = false;

  Future<void> _pickImage(BuildContext context) async {
    final formCubit = context.read<AddProductFormCubit>();
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final path = file.path; // may be null on some platforms
    final name = file.name;
    final size = file.size; // bytes length
    final bytes = file.bytes; // for web or fallback preview

    // Validate type
    final lname = name.toLowerCase();
    if (!(lname.endsWith('.png') || lname.endsWith('.jpg') || lname.endsWith('.jpeg'))) {
      formCubit.setUploadError('Format harus JPG/PNG');
      return;
    }
    // Validate size <=5MB
    const maxSize = 5 * 1024 * 1024;
    if (size > maxSize) {
      formCubit.setUploadError('Ukuran > 5MB');
      return;
    }

    // Ensure we have a real path for multipart; if missing create temp file
    String? finalPath = path;
    Uint8List? finalBytes = bytes;

    // On web we rely on bytes only (no real path)
    if (kIsWeb) {
      finalPath = null; // ensure we don't depend on path
      if (finalBytes == null) {
        formCubit.setUploadError('Bytes tidak tersedia');
        return;
      }
    } else {
      // Non-web fallback: if path missing create temp file
      if (finalPath == null) {
        try {
          final tempFile = File('${Directory.systemTemp.path}/$name');
          await tempFile.writeAsBytes(bytes ?? []);
          finalPath = tempFile.path;
        } catch (e) {
          formCubit.setUploadError('Gagal membuat file sementara');
          return;
        }
      }
    }

    formCubit.setPickedMeta(path: finalPath, fileName: name, size: size, bytes: finalBytes);
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
                // Show success bottom sheet overlay (same behavior as screen)
                if (mounted) {
                  setState(() => _showSuccess = true); // keep inline swap as fallback
                }
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black54,
                  builder: (sheetCtx) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
                      child: SafeArea(
                        child: Container(
                          color: Colors.transparent,
                          child: CustomSuccessWidget(
                            onBack: () {
                              // Close success sheet then close add sheet and go to home
                              Navigator.of(sheetCtx).pop();
                              try {
                                context.read<NavigationCubit>().updateIndex(0);
                              } catch (_) {}
                              // Close the add sheet
                              Navigator.of(context).pop();
                            },
                            onAddAnother: () {
                              // Close only the success sheet and reset form
                              Navigator.of(sheetCtx).pop();
                              try {
                                context.read<AddProductFormCubit>().reset();
                              } catch (_) {}
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
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
                  child: _showSuccess
                      ? CustomSuccessWidget(
                          onBack: () {
                            // Close the sheet and navigate to Home tab if available
                            Navigator.of(context).pop();
                            try {
                              context.read<NavigationCubit>().updateIndex(0);
                            } catch (_) {}
                          },
                          onAddAnother: () {
                            // Reset to form mode and clear fields
                            setState(() => _showSuccess = false);
                            try {
                              context.read<AddProductFormCubit>().reset();
                            } catch (_) {}
                          },
                        )
                      : BlocBuilder<AddProductFormCubit, AddProductFormState>(
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
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: ((form.pickedPath != null || form.pickedBytes != null) && form.pickedFileName != null)
                                  ? Column(
                                      key: const ValueKey('preview'),
                                      children: [
                                        // Preview area
                                        SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                              child: Builder(
                                                builder: (_) {
                                                  if (form.pickedBytes != null) {
                                                    return Image.memory(
                                                      form.pickedBytes!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) => const Center(child: Text('Gagal memuat gambar')),
                                                    );
                                                  }
                                                  if (form.pickedPath != null) {
                                                    return Image.file(
                                                      File(form.pickedPath!),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) => const Center(child: Text('Gagal memuat gambar')),
                                                    );
                                                  }
                                                  return const Center(child: Text('Tidak ada gambar'));
                                                },
                                              ),
                                          ),
                                        ),
                                        Container(height: 1, color: Colors.grey.shade300),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${form.pickedFileName} • ${(form.pickedFileSize! / 1024).toStringAsFixed(1)}KB',
                                                style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () => context.read<AddProductFormCubit>().clearPickedFile(),
                                                    child: const Text('Hapus'),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton(
                                                    onPressed: () => _pickImage(context),
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                      backgroundColor: const Color(0xFF1E63F9),
                                                    ),
                                                    child: const Text('Ganti'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : InkWell(
                                      key: const ValueKey('placeholder'),
                                      onTap: () => _pickImage(context),
                                      child: SizedBox(
                                        height: 160,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
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
                                              form.pickedFileName == null
                                                  ? '-'
                                                  : '${form.pickedFileName} • ${(form.pickedFileSize! / 1024).toStringAsFixed(1)}KB',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: form.errorMessage != null ? Colors.redAccent : Colors.black54,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            if (form.errorMessage != null) ...[
                                              const SizedBox(height: 6),
                                              Text(
                                                form.errorMessage!,
                                                style: const TextStyle(fontSize: 11, color: Colors.redAccent),
                                              ),
                                            ],
                                          ],
                                        ),
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
                                            picturePath: formState.pickedPath,
                                            pictureBytes: formState.pickedBytes,
                                            pictureFilename: formState.pickedFileName,
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
