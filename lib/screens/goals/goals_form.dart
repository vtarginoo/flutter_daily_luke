import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:flutter/material.dart';

import '../../models/goal.dart';

class GoalsForm extends StatefulWidget {
  const GoalsForm({super.key});

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final GoalDao _dao = GoalDao();
  String? _percentError;

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
                      width: 2.0, // Linha quando o campo está focado
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _percentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Percentual Desejado",
                      labelStyle:
                          const TextStyle(color: Colors.blue, fontSize: 18),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      errorText: _percentError,
                    ),
                    onChanged: (value) {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue == null ||
                          parsedValue < 0 ||
                          parsedValue > 100) {
                        setState(() {
                          _percentError = "Insira um valor entre 0 e 100";
                        });
                      } else {
                        setState(() {
                          _percentError = null;
                        });
                      }
                    },
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final currentValue =
                        double.tryParse(_percentController.text) ?? 0;
                    if (currentValue > 0) {
                      _percentController.text = (currentValue - 1).toString();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final currentValue =
                        double.tryParse(_percentController.text) ?? 0;
                    if (currentValue < 100) {
                      _percentController.text = (currentValue + 1).toString();
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    final String name = _nameController.text;
                    final double? percentGoal =
                        double.tryParse(_percentController.text);
                    if (percentGoal == null ||
                        percentGoal < 0 ||
                        percentGoal > 100) {
                      setState(() {
                        _percentError = "Insira um valor válido entre 0 e 100";
                      });
                      return;
                    }
                    final newGoal =
                        Goal(0, name: name, targetPercentage: percentGoal);
                    _dao.save(newGoal).then(
                          (id) => Navigator.pop(context),
                        );
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
