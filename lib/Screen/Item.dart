import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'This is the new screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
