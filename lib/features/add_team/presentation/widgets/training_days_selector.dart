import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/add_team_form_provider.dart';

class TrainingDaysSelector extends StatelessWidget {
  const TrainingDaysSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    final days = [
      'السبت',
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff0048FF) : Colors.white,
              border: Border.all(
                  color: isSelected
                      ? const Color(0xff0048FF)
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
    );
  }
}
