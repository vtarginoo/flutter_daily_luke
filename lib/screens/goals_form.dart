import 'package:flutter/material.dart';

class GoalsForm extends StatelessWidget {
  const GoalsForm({super.key});

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
                decoration: InputDecoration(
                  labelText: "Nome da Meta",
                ),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Percentual Desejado",
                ),
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: double.maxFinite,

              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                ),
                onPressed: () {},
                child: Text(
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
