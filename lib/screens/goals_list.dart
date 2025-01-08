import 'package:flutter/material.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Metas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "Academia",
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text(
                "80%",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        shape: CircleBorder(),
        elevation: 5,
      ),
    );
  }
}
