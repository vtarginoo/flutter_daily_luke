import 'package:daily_luke/screens/home.dart';
import 'package:flutter/material.dart';

import 'database/dao/goal_dao.dart';

void main() {
  final GoalDao _dao = GoalDao();
  runApp(const DailyLuke());



}

class DailyLuke extends StatelessWidget {
  const DailyLuke({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blueAccent[900],
          hintColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          )),
      home: const Home(),
    );
  }
}
