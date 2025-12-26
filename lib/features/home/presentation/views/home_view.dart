import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/team_entity.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';
import 'package:blue_bird/features/home/presentation/widgets/team_card.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<HomeCubit>();
    return BlocProvider<HomeCubit>(
      create: (_) => cubit..getCurrentUser(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          context.read<HomeCubit>().getTeams(state.user.id);
        }
      },
      builder: (context, state) {
        if (state is UserLoading || state is HomeInitial) {
          return _buildLoading();
        }

        if (state is UserError) {
          return _buildError(
            context,
            onRetry: () => context.read<HomeCubit>().getCurrentUser(),
          );
        }

        UserEntity? user;
        if (state is UserLoaded) {
          user = state.user;
        } else {
          user = context.read<HomeCubit>().currentUser;
        }

        if (state is TeamsLoading) {
          return _buildLoading();
        }

        if (state is TeamsError) {
          return _buildError(
            context,
            onRetry: () => context.read<HomeCubit>().getTeams(user!.id),
          );
        }

        if (state is TeamsLoaded) {
          return _buildContent(context, user!, state.teams);
        }

        return _buildLoading();
      },
    );
  }

  // ================= UI PARTS =================

  Widget _buildLoading() {
    return Center(
      child: Lottie.asset(
        LottieAssets.loading,
        width: 180,
      ),
    );
  }

  Widget _buildError(BuildContext context, {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(StringsManager.somethingWentWrong.tr()),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(StringsManager.tryAgain.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UserEntity user,
    List<TeamEntity> teams,
  ) {
    return SingleChildScrollView(
      // physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeader(context, user, teams.length),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: teams.asMap().entries.map((entry) {
                final index = entry.key;
                final team = entry.value;

                return TweenAnimationBuilder<Offset>(
                  tween: Tween(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ),
                  duration: Duration(milliseconds: 300 + index * 100),
                  curve: Curves.easeOut,
                  builder: (_, offset, child) {
                    return Transform.translate(
                      offset: offset * 100,
                      child: Opacity(
                        opacity: 1 - offset.dy,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TeamCard(
                      teamName: team.teamName,
                      teamAge: team.teamAgeCategory,
                      numberOfPlayers: team.players.length,
                      trainingDays: team.trainingDays,
                      teamId: team.id,
                      trainerId: user.id,
                      players: team.players,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity user, int teamsCount) {
    final cubit = getIt<HomeCubit>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          transform: GradientRotation(45 * 3.14 / 180),
          colors: [
            ColorManager.primary,
            ColorManager.lightPrimary,
            ColorManager.primary,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TOP ROW =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringsManager.welcome.tr(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.desplayName ?? 'Coach',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Football Academy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    cubit.logout();
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.splashScreen,
                    );
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===== STATS =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AnimatedStatItem(
                    title: StringsManager.totalPlayers.tr(),
                    value: '0',
                  ),
                  _AnimatedStatItem(
                    title: StringsManager.teams.tr(),
                    value: teamsCount.toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== ADD TEAM BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sports_soccer),
                label: Text(StringsManager.addTeam.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ColorManager.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addTeamScreen,
                    arguments: {'trainerId': user.id},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= COMPONENTS =================

class _AnimatedStatItem extends StatelessWidget {
  final String title;
  final String value;

  const _AnimatedStatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final endValue = double.tryParse(value) ?? 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: endValue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (_, val, __) {
        return Column(
          children: [
            Text(
              val.toInt().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
