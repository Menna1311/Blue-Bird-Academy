// login_view.dart

import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/providers/user_provider.dart';
import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/auth/login/presentation/cubit/login_cubit_cubit.dart';
import 'package:blue_bird/features/auth/login/presentation/widgets/login_view_body.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final cubit = getIt<LoginCubitCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        cubit.checkUserToken();
        return cubit;
      },
      child: const Scaffold(
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
        if (state is TokenChecked) {
          if (state.user == null) return;
          context.read<UserProvider>().setUser(state.user!);
          if (state.user!.role.toLowerCase() == 'parent') {
            Navigator.pushReplacementNamed(context, AppRoutes.parentHome);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
          }
        } else if (state is LoginCubitSuccess) {
          context.read<UserProvider>().setUser(state.user);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${StringsManager.welcome.tr()} ${state.user.email}',
                style: TextStyle(fontSize: context.setSp(14)),
              ),
            ),
          );
          if (state.user.role.toLowerCase() == 'parent') {
            Navigator.pushReplacementNamed(context, AppRoutes.parentHome);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
          }
        } else if (state is LoginCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontSize: context.setSp(14)),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoginCubitLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  LottieAssets.loading,
                  width: context.setWidth(200),
                ),
                SizedBox(height: context.setHeight(16)),
                Text(
                  StringsManager.loading.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.setSp(16),
                  ),
                ),
              ],
            ),
          );
        }
        return const LoginViewBody();
      },
    );
  }
}
