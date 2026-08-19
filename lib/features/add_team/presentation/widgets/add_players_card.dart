import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/player_entity.dart';

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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group_outlined, color: ColorManager.primary),
              const SizedBox(width: 8),
              Text(
                "${StringsManager.addPlayersTitle.tr()} (${players.length})",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: context.setSp(16)),
              ),
            ],
          ),
          SizedBox(height: context.setHeight(12)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: StringsManager.playerName.tr(),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.setWidth(8)),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: StringsManager.jerseyNumber.tr(),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.setWidth(8)),
              GestureDetector(
                onTap: addPlayer,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.setWidth(12),
                      vertical: context.setHeight(14)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [
                      ColorManager.primary,
                      ColorManager.lightPrimary
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 18, color: Colors.white),
                      SizedBox(width: context.setWidth(6)),
                      Text(StringsManager.add.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: context.setSp(14))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.setHeight(16)),
          ...players.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: context.setHeight(8)),
              padding: EdgeInsets.symmetric(
                  horizontal: context.setWidth(12),
                  vertical: context.setHeight(10)),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ColorManager.primary, ColorManager.lightPrimary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => removePlayer(index),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  Text(player.name,
                      style: TextStyle(
                          fontSize: context.setSp(16), color: Colors.white)),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(player.jerseyNumber,
                        style: TextStyle(
                            color: Colors.white, fontSize: context.setSp(14))),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
