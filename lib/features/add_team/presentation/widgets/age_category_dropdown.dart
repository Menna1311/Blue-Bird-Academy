import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgeCategoryDropdown extends StatelessWidget {
  const AgeCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);

    return DropdownButtonFormField<String>(
      value: provider.ageCategory,
      items: StringsManager.ageCategoriesKeys
          .map(
            (key) => DropdownMenuItem(
              value: key,
              child: Text(key.tr()), // 🔥 localized here
            ),
          )
          .toList(),
      onChanged: provider.setAgeCategory,
      decoration: InputDecoration(
        hintText: StringsManager.selectAgeCategory.tr(),
        filled: true,
        fillColor: const Color(0xffF8F9FD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
