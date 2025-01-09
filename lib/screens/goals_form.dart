import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:flutter/material.dart';

import '../models/goal.dart';

class GoalsForm extends StatefulWidget {
  const GoalsForm({super.key});

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final GoalDao _dao = GoalDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nova Meta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome da Meta",
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0), // Linha quando o campo está focado
                  ),
                ),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _percentController,
                decoration: const InputDecoration(
                  labelText: "Percentual Desejado",
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  fillColor: Colors.blueAccent,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0), // Linha quando o campo está focado
                  ),
                ),
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                ),
                onPressed: () {
                  final String name = _nameController.text;
                  final double percentGoal =
                      double.tryParse(_percentController.text)!;
                  final newGoal = Goal(0, name: name, percent: percentGoal);
                  _dao.save(newGoal).then((id) => Navigator.pop(context),);
                },
                child: const Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
