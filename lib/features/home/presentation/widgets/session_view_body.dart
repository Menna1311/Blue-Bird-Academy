import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/presentation/views/attendance_histoy_view.dart';
import 'package:blue_bird/features/home/presentation/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';

class SessionViewBody extends StatelessWidget {
  final String trainerId;
  final String teamId;
  final List<PlayerEntity> players;
  const SessionViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<HomeCubit>();
    // Pass both trainerId and teamId
    cubit.getSessions(trainerId, teamId);

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is SessionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SessionsLoaded) {
          final sessions = state.sessions;
          if (sessions.isEmpty) {
            return const Center(child: Text("لا يوجد جلسات حتى الآن"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final isUpcoming = session.status == 'upcoming';
                    final statusText = isUpcoming ? 'قادمة' : 'مكتملة';

                    return SessionCard(
                      dayName: session.day,
                      date: session.date,
                      time: session.time,
                      status: statusText,
                      isUpcoming: isUpcoming,
                      onPressed: () {
                        // Pass all three parameters: trainerId, teamId, sessionId
                        cubit.getSession(trainerId, teamId, session.id);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.attendanceScreen,
                          arguments: {
                            'trainerId': trainerId,
                            'teamId': teamId,
                            'sessionId': session.id,
                            'players': players,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceHistoryScreen(
                          trainerId: trainerId,
                          teamId: teamId,
                        ),
                      ),
                    );
                  },
                  child: const Text("السجل"),
                ),
              ),
            ],
          );
        } else if (state is SessionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("حدث خطأ أثناء تحميل الجلسات"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    cubit.getSessions(trainerId, teamId);
                  },
                  child: const Text("إعادة المحاولة"),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
