// onboarding_screen.dart
import 'package:blue_bird/features/intro/onboarding_screen/view/widgets/on_boarding_page.dart';
import 'package:blue_bird/features/intro/onboarding_screen/view/widgets/onboarding_controls.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/on_boarding_data.dart';
import '../view_model/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, int>(
        builder: (context, currentIndex) {
          final cubit = context.read<OnboardingCubit>();

          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: cubit.getPageController,
                        itemCount: OnBoardingData.onboardingData.length,
                        onPageChanged: cubit.updatePage,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                    scale: animation, child: child),
                              );
                            },
                            child: OnboardingPage(
                              key: ValueKey(index),
                              image: OnBoardingData.onboardingData[index]
                                  ["image"]!,
                              title: OnBoardingData.onboardingData[index]
                                      ["title"]!
                                  .tr(),
                              description: OnBoardingData.onboardingData[index]
                                      ["description"]!
                                  .tr(),
                            ),
                          );
                        },
                      ),
                      const SkipButton(),
                    ],
                  ),
                ),
                OnboardingControls(
                  pageController: cubit.getPageController,
                  totalPages: OnBoardingData.onboardingData.length,
                  currentPageIndex: currentIndex,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
