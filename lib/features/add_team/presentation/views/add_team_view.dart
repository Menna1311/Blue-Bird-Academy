import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/features/add_team/presentation/cubit/add_team_cubit.dart';
import 'package:blue_bird/features/add_team/presentation/widgets/add_team_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTeamView extends StatelessWidget {
  const AddTeamView({super.key, this.arguments});
  final Map<String, dynamic>? arguments;
  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final cubit = getIt<AddTeamCubit>();
    return Scaffold(
      body: BlocProvider(
        create: (context) => cubit,
        child: AddTeamViewBody(trainerId: trainerId),
      ),
    );
  }
}
