import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/player_entity.dart';
import '../provider/add_team_form_provider.dart';

class AddPlayersCard extends StatefulWidget {
  const AddPlayersCard({super.key});

  @override
  State<AddPlayersCard> createState() => _AddPlayersCardState();
}

class _AddPlayersCardState extends State<AddPlayersCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    final players = provider.players;

    void addPlayer() {
      if (nameController.text.isEmpty || numberController.text.isEmpty) return;
      final newPlayers = List<PlayerEntity>.from(players)
        ..add(PlayerEntity(
            name: nameController.text,
            jerseyNumber: numberController.text,
            id: ''));
      provider.setPlayers(newPlayers);
      nameController.clear();
      numberController.clear();
    }

    void removePlayer(int index) {
      final newPlayers = List<PlayerEntity>.from(players)..removeAt(index);
      provider.setPlayers(newPlayers);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group_outlined, color: Colors.blue),
                const SizedBox(width: 8),
                Text("إضافة لاعبين (${players.length})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: nameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "اسم اللاعب",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: numberController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "رقم القميص",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: addPlayer,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("إضافة"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...players.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => removePlayer(index),
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                    Text(player.name, style: const TextStyle(fontSize: 16)),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blue[100],
                      child: Text(player.jerseyNumber,
                          style: const TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
