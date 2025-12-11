import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/auth/login/presentation/cubit/login_cubit_cubit.dart';
import 'package:blue_bird/features/auth/login/presentation/widgets/login_view_body.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final cubit = getIt<LoginCubitCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        cubit.checkUserToken(); // 🔥 CHECK TOKEN ON START
        return cubit;
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body: const LoginBlocConsumer(),
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
        if (state is TokenChecked) {
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        } else if (state is LoginCubitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${state.user.email}')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        } else if (state is LoginCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is LoginCubitLoading || state is LoginCubitInitial) {
          // show loading until token check is finished
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lotti/Footballer_loading.json',
                  width: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else if (state is NoToken) {
          return const LoginViewBody();
        }

        // fallback (should not happen)
        return const SizedBox.shrink();
      },
    );
  }
}
