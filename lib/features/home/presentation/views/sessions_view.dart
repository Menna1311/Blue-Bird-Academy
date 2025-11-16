import 'package:blue_bird/features/home/presentation/widgets/session_view_body.dart';
import 'package:flutter/material.dart';

class SessionsView extends StatelessWidget {
  final Map<String, String>? arguments;

  const SessionsView({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];

    if (trainerId == null || teamId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Sessions")),
        body: const Center(child: Text("Missing parameters")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Sessions")),
      body: SessionViewBody(
        trainerId: trainerId,
        teamId: teamId,
      ),
    );
  }
}
