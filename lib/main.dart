import 'package:daily_luke/database/app_database.dart';
import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/screens/home.dart';
import 'package:flutter/material.dart';

import 'database/dao/goal_dao.dart';

void main() async {
  final GoalDao _dao1 = GoalDao();
  final DailyInputDao _dao2 = DailyInputDao();
  WidgetsFlutterBinding.ensureInitialized();
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
