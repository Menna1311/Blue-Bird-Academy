import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: context.setWidth(8)),
              padding: EdgeInsets.symmetric(
                  horizontal: context.setWidth(18),
                  vertical: context.setHeight(10)),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          ColorManager.primary,
                          ColorManager.lightPrimary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isSelected ? ColorManager.primary : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorManager.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                dayKey.tr(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: context.setSp(14),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
