import 'package:flutter/material.dart';

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
      ),
      body: const Center(
        child: Text('Welcome, Parent!'),
      ),
    );
  }
}
