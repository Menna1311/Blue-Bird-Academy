import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/auth/login/presentation/widgets/login_form.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
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
        LoginForm(),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.registerScreen);
            },
            child: Text(StringsManager.registerNow,
                style: AppTextStyles.font18W400White(context))),
      ],
    );
  }
}
