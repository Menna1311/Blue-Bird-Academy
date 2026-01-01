import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.teamName,
    required this.teamAge,
    required this.numberOfPlayers,
    required this.trainingDays,
    required this.teamId,
    required this.trainerId,
    required this.players,
  });

  final String teamName;
  final String teamAge;
  final int numberOfPlayers;
  final List<String> trainingDays;
  final String teamId;
  final String trainerId;
  final List<PlayerEntity> players;

  @override
  Widget build(BuildContext context) {
    final formattedDays = trainingDays.join(', ');

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.attendanceScreen, arguments: {
          'trainerId': trainerId,
          'teamId': teamId,
          'players': players,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [ColorManager.primary, ColorManager.lightPrimary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withOpacity(0.4),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Team info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teamName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$teamAge years',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        formattedDays,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Player count with gradient circle
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [ColorManager.primary, ColorManager.lightPrimary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.group, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '$numberOfPlayers players',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
