import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/add_team_form_provider.dart';

class TrainingDaysSelector extends StatelessWidget {
  const TrainingDaysSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    final days = StringsManager.trainingDaysList;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: days.map((day) {
          final isSelected = provider.trainingDays.contains(day);
          return GestureDetector(
            onTap: () {
              final newList = List<String>.from(provider.trainingDays);
              if (isSelected) {
                newList.remove(day);
              } else {
                newList.add(day);
              }
              provider.setTrainingDays(newList);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primary : Colors.white,
                border: Border.all(
                    color: isSelected
                        ? ColorManager.primary
                        : Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(day,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
