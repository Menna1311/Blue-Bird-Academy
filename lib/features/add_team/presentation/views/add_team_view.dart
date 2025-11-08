import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/features/add_team/presentation/cubit/add_team_cubit.dart';
import 'package:blue_bird/features/add_team/presentation/widgets/add_team_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTeamView extends StatelessWidget {
  AddTeamView({super.key});
  final cubit = getIt<AddTeamCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => cubit,
        child: const AddTeamViewBody(),
      ),
    );
  }
}
