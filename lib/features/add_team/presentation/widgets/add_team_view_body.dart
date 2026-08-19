import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final screenWidth = context.screenWidth;

    return ChangeNotifierProvider(
      create: (_) => AddTeamFormProvider(),
      child: Consumer<AddTeamFormProvider>(
        builder: (context, provider, _) {
          return BlocConsumer<AddTeamCubit, AddTeamState>(
            listener: (context, state) {
              if (state is AddTeamSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(StringsManager.teamAddedSuccessfully.tr())),
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
                    SizedBox(height: context.setHeight(20)),
                    TeamComponent(
                      title: StringsManager.teamName.tr(),
                      widget: TextField(
                        controller: provider.teamNameController,
                        decoration: InputDecoration(
                          hintText: StringsManager.teamName.tr(),
                          filled: true,
                          fillColor: const Color(0xffF8F9FD),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: provider.setTeamName,
                      ),
                    ),
                    SizedBox(height: context.setHeight(20)),
                    TeamComponent(
                      title: StringsManager.ageCategory.tr(),
                      widget: const AgeCategoryDropdown(),
                    ),
                    SizedBox(height: context.setHeight(20)),
                    TeamComponent(
                      title: StringsManager.trainingDays.tr(),
                      widget: const TrainingDaysSelector(),
                    ),
                    SizedBox(height: context.setHeight(20)),
                    TeamComponent(
                      title: StringsManager.trainingTime.tr(),
                      widget: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) provider.setTrainingTime(time);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: context.setHeight(14),
                              horizontal: context.setWidth(16)),
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F9FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            provider.trainingTime != null
                                ? '${provider.trainingTime!.hour.toString().padLeft(2, '0')}:${provider.trainingTime!.minute.toString().padLeft(2, '0')}'
                                : StringsManager.selectTrainingTime.tr(),
                            style: TextStyle(fontSize: context.setSp(14)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.setHeight(20)),
                    TeamComponent(
                      title: StringsManager.addPlayers.tr(),
                      widget: const AddPlayersCard(),
                    ),
                    SizedBox(height: context.setHeight(30)),
                    state is AddTeamLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () => _submitTeam(context, provider),
                            child: Container(
                              width: screenWidth * 0.8,
                              padding: EdgeInsets.symmetric(
                                  vertical: context.setHeight(16)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                  colors: [
                                    ColorManager.primary,
                                    ColorManager.lightPrimary
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        ColorManager.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  StringsManager.addTeam.tr(),
                                  style: AppTextStyles.font18W400White(context),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: context.setHeight(30)),
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
        SnackBar(content: Text(StringsManager.pleaseCompleteAllFields.tr())),
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
      trainerId: trainerId,
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
      padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(20), vertical: context.setHeight(30)),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primary, ColorManager.lightPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringsManager.addNewTeam.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: context.setSp(22),
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
