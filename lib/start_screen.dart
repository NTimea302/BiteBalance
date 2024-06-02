import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Screen'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Start Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}