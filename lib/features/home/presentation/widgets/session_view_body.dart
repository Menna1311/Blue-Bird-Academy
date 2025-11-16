import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/home/presentation/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';

class SessionViewBody extends StatelessWidget {
  final String trainerId;
  final String teamId;

  const SessionViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<HomeCubit>();
    cubit.getSessions(trainerId, teamId); // fetch sessions on build

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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final isUpcoming = session.status == 'upcoming';
              final statusText = isUpcoming ? 'قادمة' : 'مكتملة';

              return SessionCard(
                dayName: session.day,
                date: session.date,
                time: session.time.toDate().toString().split(' ')[1],
                status: statusText,
                isUpcoming: isUpcoming,
                onPressed: () {
                  cubit.getSession(trainerId, teamId, session.id);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.attendanceScreen, // your route
                    arguments: {
                      'trainerId': trainerId,
                      'teamId': teamId,
                      'sessionId': session.id,
                      'players': session.players
                    },
                  );
                },
              );
            },
          );
        } else if (state is SessionError) {
          return Center(child: Text(state.exception.toString()));
        }

        return const SizedBox();
      },
    );
  }
}
