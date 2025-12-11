// splash_screen.dart
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/intro/onboarding_screen/onboarding_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/assets_manager.dart';
import '../../onboarding_screen/view/onboarding_screen.dart';
import '../view_model/splash_state.dart';
import '../view_model/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) async {
          if (state is SplashFinished) {
            final hasSeenOnboarding =
                await SharedPreferencesService.hasSeenOnboarding();

            if (hasSeenOnboarding) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.loginScreen,
                (route) => false,
              );
            } else {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const OnboardingScreen(),
                ),
              );
            }
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
