import 'package:flutter/material.dart';

class TeamComponent extends StatelessWidget {
  const TeamComponent({super.key, required this.widget, required this.title});
  final Widget widget;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        border: Border.all(color: Colors.grey, width: .5),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          widget,
        ],
      ),
    );
  }
}
