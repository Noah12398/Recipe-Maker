import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'This is the new screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
