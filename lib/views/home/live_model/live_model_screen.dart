import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart' show CustomAppBar;

class LiveModelScreen extends StatelessWidget {
  const LiveModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Live Model'),
      body: Column(
        children: [
          const Text('Live Model'),
          const Text('Live Model'),
        ],
      ),
    );
  }
}
