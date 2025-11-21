import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/choose_payment/choose_payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  // Set Initial State (Default terpilih: QRIS)
  PaymentCubit() : super(const PaymentState(selectedPayment: 'QRIS'));

  // Fungsi untuk mengubah pilihan
  void selectPayment(String paymentMethod) {
    emit(PaymentState(selectedPayment: paymentMethod));
  }
}
