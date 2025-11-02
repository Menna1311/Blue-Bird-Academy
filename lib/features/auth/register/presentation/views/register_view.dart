import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/widgets/custom_textfield.dart';
import 'package:blue_bird/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final cubit = getIt<RegisterCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushNamed(context, AppRoutes.homeScreen);
            } else if (state is RegisterFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is RegisterLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading...')),
              );
            }
          },
          builder: (context, state) {
            return RegisterViewBody();
          },
        ),
      ),
    );
  }
}

class RegisterViewBody extends StatelessWidget {
  RegisterViewBody({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hint: 'Email',
            controller: emailController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Password',
            controller: passwordController,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();
              if (email.isNotEmpty && password.isNotEmpty) {
                cubit.regiser(email, password);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter all fields')),
                );
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
