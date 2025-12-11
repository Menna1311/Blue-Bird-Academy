import 'package:flutter/material.dart';

class BlurredContainer extends StatelessWidget {
  final Widget child;
  final bool condition;

  const BlurredContainer({
    super.key,
    required this.child,
    this.condition = false,
  });

  @override
  Widget build(BuildContext context) {
    return     Container(

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius:  BorderRadius.only(topLeft:Radius.circular(condition ? 30  : 0) ,topRight: Radius.circular(condition ? 24 : 0)),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: child,
    );

  }
}
