import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/providers/user_provider.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/core/service/secure_storage_service.dart';
import 'package:blue_bird/features/intro/onboarding_screen/onboarding_helper.dart';
import 'package:blue_bird/features/intro/onboarding_screen/view/onboarding_screen.dart';
import 'package:blue_bird/features/intro/splash_screen/view_model/splash_state.dart';
import 'package:blue_bird/features/intro/splash_screen/view_model/splash_view_model.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(
        getIt<AuthService>(),
        getIt<SecureStorageService>(),
      )..checkAuthAndNavigate(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) async {
          if (state is SplashNavigateToLogin) {
            // First-launch → show onboarding; returning user → show login.
            final hasSeenOnboarding =
                await SharedPreferencesService.hasSeenOnboarding();

            if (!context.mounted) return;

            if (hasSeenOnboarding) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.loginScreen,
                (route) => false,
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const OnboardingScreen(),
                ),
              );
            }
          } else if (state is SplashNavigateToTrainer) {
            // Persist the resolved user so every screen can read it immediately.
            if (!context.mounted) return;
            context.read<UserProvider>().setUser(state.user);
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.mainLayout,
              (route) => false,
            );
          } else if (state is SplashNavigateToParent) {
            if (!context.mounted) return;
            context.read<UserProvider>().setUser(state.user);
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.parentHome,
              (route) => false,
            );
          }
        },
        child: const Scaffold(
          body: Center(
            child: Image(
              image: AssetImage(ImageAssets.logo),
            ),
          ),
        ),
      ),
    );
  }
}
