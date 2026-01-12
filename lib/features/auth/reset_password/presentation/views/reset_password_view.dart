import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/widgets/custom_textfield.dart';
import 'package:blue_bird/features/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ResetPasswordCubit>();
    final controller = TextEditingController();

    return BlocProvider(
      create: (_) => cubit,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            builder: (context, state) {
              if (state is ResetPasswordSuccess) {
                return _SuccessView();
              }

              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]),
                    const Icon(
                      Icons.lock_reset_rounded,
                      size: 46,
                      color: ColorManager.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reset Password'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your email to receive a reset link'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      hint: 'Enter your email'.tr(),
                      controller: controller,
                    ),
                    const SizedBox(height: 24),

                    /// Gradient Button
                    GestureDetector(
                      onTap: state is ResetPasswordLoading
                          ? null
                          : () {
                              cubit.resetPassword(controller.text);
                            },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primary,
                              ColorManager.primary.withOpacity(0.85),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.primary.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: state is ResetPasswordLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Send Reset Link'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lotti/Email motion loading.json',
            height: 160,
          ),
          const SizedBox(height: 16),
          Text(
            'Check your email'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We’ve sent you a link to reset your password.'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
