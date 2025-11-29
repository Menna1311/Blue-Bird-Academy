import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.teamName,
    required this.teamAge,
    required this.numberOfPlayers,
    required this.date,
    required this.teamId,
    required this.trainerId,
    required this.players,
  });

  final String teamName;
  final String teamAge;
  final int numberOfPlayers;
  final DateTime date;
  final String teamId;
  final String trainerId;
  final List<PlayerEntity> players;
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE، d MMMM • HH:mm').format(date); // Arabic format

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.sessionScreen, arguments: {
          'trainerId': trainerId,
          'teamId': teamId,
          'players': players
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
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
                    ),
                  ),
                  Text(
                    '$teamAge سنة',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Player count
            Column(
              children: [
                const Icon(Icons.group, color: Color(0xff0048FF)),
                Text(
                  '$numberOfPlayers لاعب',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
