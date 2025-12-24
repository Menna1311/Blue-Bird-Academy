import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/auth/login/presentation/widgets/login_form.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.setHeight(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginForm(),
          SizedBox(height: context.setHeight(12)),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.registerScreen);
            },
            child: Text(
              StringsManager.registerNow,
              style: AppTextStyles.font18W400White(context)
                  .copyWith(fontSize: context.setSp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
