import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/team_entity.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';
import 'package:blue_bird/features/home/presentation/widgets/team_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainerId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..getTeams(trainerId),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is TeamsLoading) {
            return Center(
              child: Lottie.asset(
                'assets/lotti/Footballer_loading.json',
                width: 180,
              ),
            );
          }

          if (state is TeamsError) {
            return const Center(
              child: Text('حدث خطأ أثناء تحميل الفرق'),
            );
          }

          if (state is TeamsLoaded) {
            final List<TeamEntity> teams = state.teams;
            final trainerId = FirebaseAuth.instance.currentUser!.uid;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, teams.length),
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
                            trainerId: trainerId,
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

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int teamsCount) {
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
              'مرحبًا بعودتك،',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'المدرب محمود كبير',
              style: TextStyle(
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
                  const _StatItem(title: 'إجمالي اللاعبين', value: '—'),
                  _StatItem(
                    title: 'الفرق',
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
              child: const Text('اضافة فريق جديد'),
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
