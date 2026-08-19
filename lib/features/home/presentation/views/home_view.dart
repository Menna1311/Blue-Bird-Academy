import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/providers/user_provider.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/week_days.dart';
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
import 'package:provider/provider.dart';

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
          return _buildContent(
            context,
            user!,
            state.filteredTeams,
          );
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
      child: Column(
        children: [
          _buildHeader(context, user, teams.length),
          const SizedBox(height: 12),
          const WeekDaysFilter(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: teams.isEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 40),
                      Lottie.asset(
                        'assets/lotti/Empty List.json',
                        width: 220,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'There is no teams yet'.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  )
                : Column(
                    children: List.generate(teams.length, (index) {
                      final team = teams[index];

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
                          child: Builder(
                            builder: (context) {
                              final cubit = context.read<HomeCubit>();
                              final upcomingSession =
                                  cubit.getUpcomingSession(team.id);

                              return TeamCard(
                                teamName: team.teamName,
                                sessionId: upcomingSession?.id ?? '',
                                teamAge: team.teamAgeCategory,
                                numberOfPlayers: team.players.length,
                                trainingDays: team.trainingDays,
                                teamId: team.id,
                                trainerId: user.id,
                                players: team.players,
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(BuildContext context, UserEntity user, int teamsCount) {
    final cubit = context.read<HomeCubit>();
    return Stack(
      children: [
        // ===== BACKGROUND SHAPE =====
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ColorManager.primary, ColorManager.lightPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),

        // ===== CONTENT =====
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW
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
                            fontSize: 24,
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

                        context.read<UserProvider>().logout();
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

                // ===== STATS CARD =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _AnimatedStatItem(
                        title: StringsManager.teams.tr(),
                        value: teamsCount.toString(),
                        textColor: ColorManager.primary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // ===== ADD TEAM BUTTON =====
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addTeamScreen,
                        arguments: {'trainerId': user.id},
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                            color: ColorManager.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.sports_soccer,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            StringsManager.addTeam.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= COMPONENTS =================

class _AnimatedStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;

  const _AnimatedStatItem({
    required this.title,
    required this.value,
    this.textColor = Colors.white,
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
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WeekDaysFilter extends StatelessWidget {
  const WeekDaysFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (_, current) => current is TeamsLoaded,
      builder: (context, state) {
        if (state is! TeamsLoaded) return const SizedBox.shrink();

        const days = WeekDay.values;

        return SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: days.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final day = isAll ? null : days[index - 1];
              final isSelected = state.selectedDay == day;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            ColorManager.primary,
                            ColorManager.lightPrimary
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: ColorManager.primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => context.read<HomeCubit>().filterByDay(day),
                  child: Center(
                    child: Text(
                      isAll ? 'all'.tr() : day!.label(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ================= EXTENSIONS =================
extension GradientButton on Widget {
  Widget wrapWithGradient(
      {required Gradient gradient, BorderRadius? borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  Widget onTap(VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: this,
    );
  }
}
