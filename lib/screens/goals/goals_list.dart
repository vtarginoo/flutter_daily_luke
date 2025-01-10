import 'package:daily_luke/component/goal_item.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:daily_luke/screens/goals/goals_form.dart';
import 'package:flutter/material.dart';

class GoalsList extends StatefulWidget {
  const GoalsList({super.key});

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  final List<Goal> goals = [];
  final GoalDao _dao = GoalDao();

  @override
  Widget build(BuildContext context) {
    goals.add(Goal(0, name: 'Meditação', targetPercentage: 80));
    goals.add(Goal(0, name: 'Futebol', targetPercentage: 54));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Metas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Goal>>(
        initialData: const [],
        future: Future.delayed(const Duration(seconds: 1))
            .then((value) => _dao.findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading'),
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Goal>? goals = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Goal? goal = goals?[index];
                  return GoalItem(
                    goal: goal!,
                    onEditPressed: () {},
                  );
                },
                itemCount: goals?.length,
              );
          }
          return const Text('Unkown error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const GoalsForm(),
            ),
          )
              .then((_) {
            setState(() {});
          });
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
