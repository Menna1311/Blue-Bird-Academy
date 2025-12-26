import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComingSeenScreen extends StatelessWidget {
  const ComingSeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            LottieAssets.comingSoon,
            width: context.setWidth(400),
          ),
          Text(
            'Coming Soon!',
            style: AppTextStyles.font20W800White(context).copyWith(
              color: ColorManager.primary,
            ),
          ),
          Text('This feature will be available soon.',
              style: AppTextStyles.font18W400primary(context)),
        ],
      ),
    );
  }
}
