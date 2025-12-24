import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
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
      margin: EdgeInsets.all(context.setWidth(16)),
      padding: EdgeInsets.all(context.setWidth(16)),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(context.setMinSize(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: context.setMinSize(50),
            backgroundImage: const AssetImage(ImageAssets.logo),
          ),
          SizedBox(height: context.setHeight(20)),
          Text(
            StringsManager.blueBirdAcademy,
            style: AppTextStyles.font24W500White(context)
                .copyWith(fontSize: context.setSp(24)),
          ),
          SizedBox(height: context.setHeight(4)),
          Text(
            StringsManager.coachesAttendanceSystem,
            style: AppTextStyles.font14W800White(context)
                .copyWith(fontSize: context.setSp(14)),
          ),
          SizedBox(height: context.setHeight(20)),
          Text(
            StringsManager.login,
            style: AppTextStyles.font24W800White(context)
                .copyWith(fontSize: context.setSp(24)),
          ),
          SizedBox(height: context.setHeight(16)),
          CustomTextField(
            hint: StringsManager.coachEmail,
            onChange: cubit.updateEmail,
          ),
          SizedBox(height: context.setHeight(10)),
          CustomTextField(
            hint: StringsManager.coachPassword,
            obscureText: true,
            onChange: cubit.updatePassword,
          ),
          SizedBox(height: context.setHeight(20)),
          SizedBox(
            width: double.infinity,
            height: context.setHeight(50),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.white,
                foregroundColor: ColorManager.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    context.setMinSize(40),
                  ),
                ),
              ),
              onPressed: cubit.submit,
              child: Text(
                StringsManager.login,
                style: AppTextStyles.font18W400primary(context)
                    .copyWith(fontSize: context.setSp(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
