import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgeCategoryDropdown extends StatelessWidget {
  const AgeCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTeamFormProvider>(context);
    return DropdownButtonFormField<String>(
      value: provider.ageCategory,
      items: [
        'تحت 6 سنوات',
        'تحت 8 سنوات',
        'تحت 10 سنوات',
        'تحت 12 سنة',
        'تحت 14 سنة',
        'تحت 16 سنة',
        'تحت 18 سنة',
      ]
          .map(
            (e) => DropdownMenuItem(
                value: e, child: Text(e, textAlign: TextAlign.right)),
          )
          .toList(),
      onChanged: (value) => provider.setAgeCategory(value),
      decoration: InputDecoration(
        hintText: 'اختر الفئة العمرية',
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
