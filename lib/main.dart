import 'package:daily_luke/database/app_database.dart';
import 'package:daily_luke/screens/home.dart';
import 'package:flutter/material.dart';

import 'models/goal.dart';

void main() {

  runApp(const DailyLuke());
  save(
    Goal(0, name: 'futebol', percent: 100),
  ).then((id) {
    findAll().then(
      (goals) => debugPrint(goals.toString()),
    );
  });
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
      home: Home(),
    );
  }
}
