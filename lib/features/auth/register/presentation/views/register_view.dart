import 'package:blue_bird/core/di/di.dart';
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
                content: Text("${StringsManager.welcome} ${state.user.email}")),
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
                Lottie.asset(LottieAssets.loading, width: 200),
                const SizedBox(height: 16),
                const Text(StringsManager.loading,
                    style: TextStyle(color: Colors.white)),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(ImageAssets.logo),
              ),
              const SizedBox(height: 20),
              Text(StringsManager.blueBirdAcademy,
                  style: AppTextStyles.font24W500White(context)),
              Text(StringsManager.coachesAttendanceSystem,
                  style: AppTextStyles.font14W800White(context)),
              const SizedBox(height: 20),
              Text(
                StringsManager.register,
                style: AppTextStyles.font24W800White(context),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: StringsManager.coachEmail,
                onChange: cubit.updateEmail,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: StringsManager.coachPassword,
                obscureText: true,
                onChange: cubit.updatePassword,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                  hint: StringsManager.coachName,
                  onChange: cubit.updateUsername),
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
                onPressed: () => cubit.submit(),
                child: Text(
                  StringsManager.register,
                  style: AppTextStyles.font18W400primary(context),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            StringsManager.loginNow,
            style: AppTextStyles.font18W400White(context),
          ),
        ),
      ],
    );
  }
}
