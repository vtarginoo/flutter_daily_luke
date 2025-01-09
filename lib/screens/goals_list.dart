import 'package:daily_luke/models/goal.dart';
import 'package:daily_luke/screens/goals_form.dart';
import 'package:flutter/material.dart';

class GoalsList extends StatelessWidget {
  GoalsList({super.key});

  final List<Goal> goals = [];

  @override
  Widget build(BuildContext context) {

    goals.add(Goal(0, name: 'Meditação', percent: 80));
    goals.add(Goal(0, name: 'Futebol', percent: 54));



    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Metas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final Goal goal = goals[index];
          return _GoalItem(goal);
        },
        itemCount: goals.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => GoalsForm()),
              )
              .then(
                (newGoal) => debugPrint(newGoal.toString()),
              );
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        elevation: 5,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {

  final Goal goal;

  _GoalItem(this.goal);

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: ListTile(
        title: Text(
          goal.name,
          style: const TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          goal.percent.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
