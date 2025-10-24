import 'package:blue_bird/features/auth/login/presentation/widgets/login_form.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.shield_outlined,
          color: ColorManager.white,
          size: 100,
        ),
        Text(
          'Blue Bird Academy',
          style: AppTextStyles.font24W500White(context),
        ),
        LoginForm(),
      ],
    );
  }
}
