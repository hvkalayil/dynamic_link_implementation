import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  static const String id = 'Result Screen Id';
  final String message;
  const ResultScreen({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your message is:'),
              Text(
                message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
