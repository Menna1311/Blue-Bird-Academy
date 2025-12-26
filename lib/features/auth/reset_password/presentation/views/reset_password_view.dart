import 'package:blue_bird/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        CustomTextField(
          hint: 'Enter your email',
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: null,
          child: Text('Reset Password'),
        ),
      ],
    ));
  }
}
