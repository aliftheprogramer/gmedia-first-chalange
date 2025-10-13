// lib/features/auth/presentation/widgets/login_form_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_state.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/visible/password_visible_cubit.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/visible/password_visible_state.dart';
import 'package:gmedia_project/widget/custom_text_field.dart';

class LoginFormCard extends StatefulWidget {
  const LoginFormCard({super.key});

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selamat Datang di MASPOS',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk klola bisnis kamu dengan mudah dan efisien. MASPOS hadirkan solusi point-of-sale terbaik untuk kemudahan operasional sehari-hari.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
              
                CustomTextField(
                  controller: _emailController,
                  label: 'Username',
                  hintText: 'Masukkan username',
                  validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong' : null,
                ),

                const SizedBox(height: 16),
                BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
                  builder: (context, state) {
                    final isHidden = state is PasswordIsHidden;
                    return CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Masukkan password',
                      obscureText: isHidden,
                      validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          context.read<PasswordVisibleCubit>().toggleVisibility();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                      child: state is LoginLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}