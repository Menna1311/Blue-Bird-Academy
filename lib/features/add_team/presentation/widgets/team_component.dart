import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';

class TeamComponent extends StatelessWidget {
  const TeamComponent({super.key, required this.widget, required this.title});
  final Widget widget;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorManager.primary,
              ),
            ),
            const SizedBox(height: 12),
            widget,
          ],
        ),
      ),
    );
  }
}
