import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/home/presentation/widgets/session_view_body.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:flutter/material.dart';

class SessionsView extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const SessionsView({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];
    final List<PlayerEntity> players = arguments?['players'];
    if (trainerId == null || teamId == null) {
      return const Scaffold(
        body: Center(child: Text(StringsManager.missingParameters)),
      );
    }

    return Scaffold(
      body: SessionViewBody(
        trainerId: trainerId,
        teamId: teamId,
        players: players,
      ),
    );
  }
}
