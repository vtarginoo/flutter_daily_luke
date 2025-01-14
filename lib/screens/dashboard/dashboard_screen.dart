import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:daily_luke/models/daily_input.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:daily_luke/screens/dashboard/visao_geral/goal_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Goal>> goals;
  late Future<List<DailyInput>> dailyInputs;
  int diasAteHoje =
      DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;

  @override
  void initState() {
    super.initState();
    goals = GoalDao().findAll(); // Carrega as metas
    dailyInputs = DailyInputDao().findAll(); // Carrega os inputs diários
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double drawerWidth = screenWidth * 0.40;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        width: drawerWidth,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Visão Geral'),
              onTap: () {
                Navigator.pop(context);
                // Adicione o redirecionamento, se necessário
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Goal>>(
          future: goals,
          builder: (context, goalSnapshot) {
            if (goalSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (goalSnapshot.hasError) {
              return const Center(child: Text('Erro ao carregar metas'));
            }

            if (!goalSnapshot.hasData || goalSnapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma meta encontrada'));
            }

            final List<Goal> goalList = goalSnapshot.data!;

            return FutureBuilder<List<DailyInput>>(
              future: dailyInputs,
              builder: (context, inputSnapshot) {
                if (inputSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (inputSnapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar inputs diários'));
                }

                if (!inputSnapshot.hasData || inputSnapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum input diário encontrado'));
                }

                final List<DailyInput> inputList = inputSnapshot.data!;

                return ListView(
                  children: [
                    const Text(
                      'Visão Geral das Metas',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$diasAteHoje/365 dias do ano',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    ...goalList.map((goal) {
                      return GoalCard(
                        goal: goal,
                        diasAteHoje: diasAteHoje,
                        inputList: inputList,
                      );
                    }),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
