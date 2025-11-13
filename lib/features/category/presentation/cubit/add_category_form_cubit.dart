import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_form_state.dart';

class AddCategoryFormCubit extends Cubit<AddCategoryFormState> {
  AddCategoryFormCubit() : super(const AddCategoryFormState());

  void setName(String value) => emit(state.copyWith(name: value));
  void reset() => emit(const AddCategoryFormState());
}
