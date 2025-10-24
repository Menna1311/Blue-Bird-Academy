import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/auth/login/presentation/cubit/login_cubit_cubit.dart';
import 'package:blue_bird/features/auth/login/presentation/widgets/login_view_body.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final cubit = getIt<LoginCubitCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body: LoginBlocConsumer(),
      ),
    );
  }
}

class LoginBlocConsumer extends StatelessWidget {
  const LoginBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubitCubit, LoginCubitState>(
      listener: (context, state) {
        if (state is LoginCubitLoading) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Logging in...')));
        } else if (state is LoginCubitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${state.user.email}')));
          Navigator.pushNamed(context, AppRoutes.homeScreen);
        } else if (state is LoginCubitError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      builder: (context, state) {
        return const LoginViewBody();
      },
    );
  }
}
