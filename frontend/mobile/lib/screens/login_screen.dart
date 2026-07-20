import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/auth_controller.dart';

class LoginScreen
    extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen>
      createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _loginController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (
      !_formKey.currentState!
          .validate()
    ) {
      return;
    }

    FocusScope.of(context).unfocus();

    final succeeded =
        await ref
            .read(
              authControllerProvider
                  .notifier,
            )
            .login(
              login:
                  _loginController.text
                      .trim(),
              password:
                  _passwordController
                      .text,
            );

    if (
      !succeeded &&
      mounted
    ) {
      final authState =
          ref.read(
        authControllerProvider,
      );

      String message =
          'Unable to sign in.';

      final error =
          authState.error;

      if (error is DioException) {
        final responseData =
            error.response?.data;

        if (
          responseData is Map &&
          responseData['detail'] !=
              null
        ) {
          final detail =
              responseData['detail'];

          if (detail is List) {
            message =
                detail.join(' ');
          } else {
            message =
                detail.toString();
          }
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState =
        ref.watch(
      authControllerProvider,
    );

    final isLoading =
        authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 460,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    Icon(
                      Icons
                          .festival_rounded,
                      size: 64,
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Welcome back',
                      textAlign:
                          TextAlign.center,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .headlineMedium,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Sign in to view your festivals and personal schedule.',
                      textAlign:
                          TextAlign.center,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller:
                          _loginController,
                      enabled:
                          !isLoading,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      textInputAction:
                          TextInputAction
                              .next,
                      autofillHints:
                          const [
                        AutofillHints
                            .username,
                        AutofillHints
                            .email,
                      ],
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Email or username',
                        prefixIcon: Icon(
                          Icons
                              .person_outline,
                        ),
                      ),
                      validator:
                          (value) {
                        if (
                          value == null ||
                          value.trim().isEmpty
                        ) {
                          return (
                            'Enter your email '
                            'or username.'
                          );
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller:
                          _passwordController,
                      enabled:
                          !isLoading,
                      obscureText:
                          _obscurePassword,
                      textInputAction:
                          TextInputAction
                              .done,
                      autofillHints:
                          const [
                        AutofillHints
                            .password,
                      ],
                      onFieldSubmitted:
                          (_) {
                        _submit();
                      },
                      decoration:
                          InputDecoration(
                        labelText:
                            'Password',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_outline,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator:
                          (value) {
                        if (
                          value == null ||
                          value.isEmpty
                        ) {
                          return (
                            'Enter your '
                            'password.'
                          );
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    FilledButton(
                      onPressed:
                          isLoading
                              ? null
                              : _submit,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2.5,
                              ),
                            )
                          : const Text(
                              'Sign in',
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}