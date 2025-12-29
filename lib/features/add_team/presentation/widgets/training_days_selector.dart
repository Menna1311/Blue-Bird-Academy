import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/add_team_form_provider.dart';

class TrainingDaysSelector extends StatelessWidget {
  const TrainingDaysSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    final daysKeys = StringsManager.trainingDaysKeys;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: daysKeys.map((dayKey) {
          final isSelected = provider.trainingDays.contains(dayKey);

          return GestureDetector(
            onTap: () {
              final newList = List<String>.from(provider.trainingDays);
              isSelected ? newList.remove(dayKey) : newList.add(dayKey);
              provider.setTrainingDays(newList);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? ColorManager.primary : Colors.grey.shade400,
                ),
              ),
              child: Text(
                dayKey.tr(), // 🔥 localized here
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
