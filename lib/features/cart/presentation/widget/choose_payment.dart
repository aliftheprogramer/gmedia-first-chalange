// lib/features/cart/presentation/widget/choose_payment.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/choose_payment/choose_payment_cubit.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/choose_payment/choose_payment_state.dart';

class ChoosePayment extends StatelessWidget {
  const ChoosePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. HANDLE BAR
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. CONTENT DENGAN BLOC BUILDER
          // BlocBuilder akan membangun ulang bagian ini setiap kali state berubah
          BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildPaymentOption(
                    context: context,
                    currentSelection: state.selectedPayment, // Data dari State
                    value: 'Tunai',
                    title: 'Tunai',
                    subtitle: 'Support text',
                    iconWidget: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.money,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildPaymentOption(
                    context: context,
                    currentSelection: state.selectedPayment, // Data dari State
                    value: 'QRIS',
                    title: 'QRIS',
                    subtitle: 'Support text',
                    iconWidget: const Icon(
                      Icons.qr_code_2,
                      color: Color(0xFF005EB8),
                      size: 40,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required String currentSelection,
    required String value,
    required String title,
    required String subtitle,
    required Widget iconWidget,
  }) {
    final bool isSelected = currentSelection == value;

    return InkWell(
      onTap: () {
        // Panggil fungsi di Cubit untuk mengubah state
        context.read<PaymentCubit>().selectPayment(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 48, height: 48, child: Center(child: iconWidget)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF2D4B55) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
