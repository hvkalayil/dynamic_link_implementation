import 'package:flutter/material.dart';
import 'package:sauda_task/Screens/HomeScreen/home_screen.dart';
import 'package:sauda_task/Screens/ResultScreen/result_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomeScreen.id: (context) => HomeScreen(),
  ResultScreen.id: (context) => ResultScreen(),
};
