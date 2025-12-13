import 'package:blue_bird/core/widgets/custom_textfield.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_bird/features/auth/login/presentation/cubit/login_cubit_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubitCubit>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(ImageAssets.logo),
          ),
          SizedBox(height: 20),
          Text(StringsManager.blueBirdAcademy,
              style: AppTextStyles.font24W500White(context)),
          Text(StringsManager.coachesAttendanceSystem,
              style: AppTextStyles.font14W800White(context)),
          const SizedBox(height: 20),
          Text(StringsManager.login,
              style: AppTextStyles.font24W800White(context)),
          CustomTextField(
            hint: StringsManager.coachEmail,
            onChange: cubit.updateEmail,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: StringsManager.coachPassword,
            obscureText: true,
            onChange: cubit.updatePassword,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: ColorManager.white,
              foregroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              cubit.submit();
            },
            child: Text(
              StringsManager.login,
              style: AppTextStyles.font18W400primary(context),
            ),
          ),
        ],
      ),
    );
  }
}
