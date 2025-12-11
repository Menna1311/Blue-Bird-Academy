// onboarding_controls.dart
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/intro/onboarding_screen/onboarding_helper.dart';
import 'package:blue_bird/features/intro/onboarding_screen/view/widgets/blured_countainer.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../view_model/onboarding_view_model.dart';

class OnboardingControls extends StatelessWidget {
  final PageController pageController;
  final int totalPages;
  final int currentPageIndex;

  const OnboardingControls({
    super.key,
    required this.pageController,
    required this.totalPages,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, pageIndex) {
        return BlurredContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SmoothPageIndicator(
                  controller: pageController,
                  count: totalPages,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    // activeDotColor: ColorManager.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (pageIndex > 0)
                      _buildAnimatedButton(
                        context,
                        text: StringsManager.onboardingBack.tr(),
                        color: ColorManager.transparent,
                        borderColor: ColorManager.primary,
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        pageIndex: pageIndex,
                        totalPages: totalPages,
                      ),
                    if (pageIndex == 0)
                      Expanded(
                        child: _buildButton(
                          context,
                          text: StringsManager.onboardingNext.tr(),
                          color: ColorManager.primary,
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      )
                    else
                      _buildAnimatedButton(
                        context,
                        text: pageIndex == totalPages - 1
                            ? StringsManager.onboardingDoIt.tr()
                            : StringsManager.onboardingNext.tr(),
                        color: ColorManager.primary,
                        onPressed: () {
                          if (pageIndex == totalPages - 1) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.loginScreen,
                              (route) => false,
                            );
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        pageIndex: pageIndex,
                        totalPages: totalPages,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required int pageIndex,
    required int totalPages,
    Color? borderColor,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: ElevatedButton(
        key: ValueKey(text),
        onPressed: () async {
          if (pageIndex == totalPages - 1) {
            await SharedPreferencesService.setOnboardingSeen();
          }
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? color),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
                      .animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            text.tr(),
            key: ValueKey<String>(text),
            style: AppTextStyles.font24W800White(context),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
    bool isExpanded = false,
    Color? borderColor,
  }) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? color),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text.tr(),
        style: AppTextStyles.font24W800White(context),
      ),
    );

    return isExpanded ? Expanded(child: button) : button;
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: TextButton(
        onPressed: () async {
          await SharedPreferencesService.setOnboardingSeen();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.loginScreen,
            (route) => false,
          );
        },
        child: Text(
          StringsManager.onboardingSkip.tr(),
          style: AppTextStyles.font18W400White(context),
        ),
      ),
    );
  }
}
