import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/team_entity.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';
import 'package:blue_bird/features/home/presentation/widgets/team_card.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..getCurrentUser(),
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
          return _buildUserError(context, state.exception);
        }
        UserEntity? user;
        if (state is UserLoaded) {
          user = state.user;
        } else if (state is TeamsLoaded ||
            state is SessionsLoaded ||
            state is SessionLoaded) {
          user = context.read<HomeCubit>().currentUser;
        }
        if (state is TeamsLoading) {
          return _buildLoading();
        }

        if (state is TeamsError) {
          return _buildTeamsError(context, user!, state.exception);
        }

        if (state is TeamsLoaded) {
          return _buildTeamsLoaded(context, user!, state.teams);
        }

        return _buildLoading();
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Lottie.asset(
        LottieAssets.loading,
        width: 180,
      ),
    );
  }

  Widget _buildUserError(BuildContext context, Exception exception) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(StringsManager.somethingWentWrong),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().getCurrentUser();
            },
            child: const Text(StringsManager.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsError(
      BuildContext context, UserEntity user, Exception exception) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(StringsManager.somethingWentWrong),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().getTeams(user.id);
            },
            child: const Text(StringsManager.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsLoaded(
      BuildContext context, UserEntity user, List<TeamEntity> teams) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, user, teams.length),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: teams.map((team) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TeamCard(
                    teamName: team.teamName,
                    teamAge: team.teamAgeCategory,
                    numberOfPlayers: team.players.length,
                    date: team.trainingTime,
                    teamId: team.id,
                    trainerId: user.id,
                    players: team.players,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xff0048FF),
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
            const Text(
              StringsManager.welcome,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.desplayName ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const _StatItem(
                      title: StringsManager.totalPlayers, value: '—'),
                  _StatItem(
                    title: StringsManager.teams,
                    value: teamsCount.toString(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addTeamScreen);
              },
              child: const Text(StringsManager.addTeam),
            )
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
