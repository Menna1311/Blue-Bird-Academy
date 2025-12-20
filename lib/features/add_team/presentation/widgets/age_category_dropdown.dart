import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgeCategoryDropdown extends StatelessWidget {
  const AgeCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    return DropdownButtonFormField<String>(
      value: provider.ageCategory,
      items: StringsManager.ageCategories
          .map(
            (e) => DropdownMenuItem(value: e, child: Text(e)),
          )
          .toList(),
      onChanged: (value) => provider.setAgeCategory(value),
      decoration: InputDecoration(
        hintText: StringsManager.selectAgeCategory,
        filled: true,
        fillColor: const Color(0xffF8F9FD),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
