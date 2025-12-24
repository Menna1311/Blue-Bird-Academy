import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import '../cubit/add_team_cubit.dart';
import 'age_category_dropdown.dart';
import 'training_days_selector.dart';
import 'add_players_card.dart';
import 'team_component.dart';
import '../../data/models/team_model.dart';

class AddTeamViewBody extends StatelessWidget {
  const AddTeamViewBody({super.key, required this.trainerId});
  final String trainerId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTeamFormProvider(),
      child: Consumer<AddTeamFormProvider>(
        builder: (context, provider, _) {
          return BlocConsumer<AddTeamCubit, AddTeamState>(
            listener: (context, state) {
              if (state is AddTeamSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(StringsManager.teamAddedSuccessfully)),
                );
                Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
              } else if (state is AddTeamFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.toString())),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    TeamComponent(
                      title: StringsManager.teamName,
                      widget: TextField(
                        controller: provider.teamNameController,
                        decoration: InputDecoration(
                          hintText: StringsManager.teamName,
                          filled: true,
                          fillColor: const Color(0xffF8F9FD),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => provider.setTeamName(value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TeamComponent(
                      title: StringsManager.ageCategory,
                      widget: AgeCategoryDropdown(),
                    ),
                    const SizedBox(height: 20),
                    const TeamComponent(
                      title: StringsManager.trainingDays,
                      widget: TrainingDaysSelector(),
                    ),
                    const SizedBox(height: 20),
                    TeamComponent(
                      title: StringsManager.trainingTime,
                      widget: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) provider.setTrainingTime(time);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(provider.trainingTime != null
                              ? '${provider.trainingTime!.hour.toString().padLeft(2, '0')}:${provider.trainingTime!.minute.toString().padLeft(2, '0')}'
                              : StringsManager.selectTrainingTime),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TeamComponent(
                      title: StringsManager.addPlayers,
                      widget: AddPlayersCard(),
                    ),
                    const SizedBox(height: 30),
                    state is AddTeamLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _submitTeam(context, provider),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              backgroundColor: ColorManager.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              StringsManager.addTeam,
                              style: AppTextStyles.font18W400White(context),
                            ),
                          ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _submitTeam(BuildContext context, AddTeamFormProvider provider) {
    if (!provider.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringsManager.pleaseCompleteAllFields)),
      );
      return;
    }

    final now = DateTime.now();
    final trainingDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      provider.trainingTime!.hour,
      provider.trainingTime!.minute,
    );

    final team = TeamModel(
      id: '',
      trainerId: trainerId, // Use the passed trainer ID
      teamName: provider.teamName,
      teamAgeCategory: provider.ageCategory!,
      trainingDays: provider.trainingDays,
      trainingTime: trainingDateTime,
      players: provider.players,
      createdAt: DateTime.now(),
    );

    context.read<AddTeamCubit>().addTeam(team.trainerId, team);
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              StringsManager.addNewTeam,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
