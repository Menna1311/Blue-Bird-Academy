import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/widgets/custom_textfield.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final cubit = getIt<RegisterCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: const Scaffold(
        backgroundColor: ColorManager.primary,
        body: RegisterBlocConsumer(),
      ),
    );
  }
}

class RegisterBlocConsumer extends StatelessWidget {
  const RegisterBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${StringsManager.welcome} ${state.user.email}",
                style: TextStyle(fontSize: context.setSp(14)),
              ),
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        }
      },
      builder: (context, state) {
        if (state is RegisterLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  LottieAssets.loading,
                  width: context.setWidth(200),
                ),
                SizedBox(height: context.setHeight(16)),
                Text(
                  StringsManager.loading,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.setSp(16),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RegisterFail) {
          return RegisterViewBody(error: state.message);
        }

        return const RegisterViewBody();
      },
    );
  }
}

class RegisterViewBody extends StatelessWidget {
  final String? error;
  const RegisterViewBody({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.setHeight(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(context.setWidth(16)),
            padding: EdgeInsets.all(context.setWidth(16)),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                context.setMinSize(10),
              ),
            ),
            child: Column(
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
                  StringsManager.register,
                  style: AppTextStyles.font24W800White(context)
                      .copyWith(fontSize: context.setSp(24)),
                ),
                SizedBox(height: context.setHeight(20)),
                CustomTextField(
                  hint: StringsManager.coachEmail,
                  onChange: cubit.updateEmail,
                ),
                SizedBox(height: context.setHeight(12)),
                CustomTextField(
                  hint: StringsManager.coachPassword,
                  obscureText: true,
                  onChange: cubit.updatePassword,
                ),
                SizedBox(height: context.setHeight(12)),
                CustomTextField(
                  hint: StringsManager.coachName,
                  onChange: cubit.updateUsername,
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
                      StringsManager.register,
                      style: AppTextStyles.font18W400primary(context)
                          .copyWith(fontSize: context.setSp(18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (error != null) ...[
            SizedBox(height: context.setHeight(8)),
            Text(
              error!,
              style: TextStyle(
                color: Colors.red,
                fontSize: context.setSp(14),
              ),
            ),
          ],
          SizedBox(height: context.setHeight(8)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringsManager.loginNow,
              style: AppTextStyles.font18W400White(context)
                  .copyWith(fontSize: context.setSp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
