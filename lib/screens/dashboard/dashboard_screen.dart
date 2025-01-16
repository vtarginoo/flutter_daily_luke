import 'package:daily_luke/models/daily_input.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:daily_luke/screens/dashboard/visao_geral/general_card.dart';
import 'package:daily_luke/screens/dashboard/visao_geral/general_chart.dart';
import 'package:daily_luke/service/dashboard_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService dashboardService = DashboardService();
  final int diasAteHoje = DashboardService.daysElapsed;

  late List<Goal> goalList;
  late List<DailyInput> dailyInputs;

  List<BarChartGroupData> barGroups = [];
  Map<int, String> goalNames = {};
  Map<int, double> goalProgress = {};
  Map<int, int> goalDaysOfProgress = {};

  @override
  void initState() {
    super.initState();
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
          future: dashboardService.findAllGoal(),
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

            goalList = goalSnapshot.data!;

            return FutureBuilder<List<DailyInput>>(
              future: dashboardService.findAllDailyInput(),
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

                return FutureBuilder<void>(
                  future: _loadData(),
                  builder: (context, chartSnapshot) {
                    if (chartSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children: [
                        const Text(
                          'Visão Geral das Metas',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$diasAteHoje/365 dias do ano',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ...goalList.map((goal) {
                          return GeneralCard(
                            goal: goal,
                            diasAteHoje: diasAteHoje,
                            daysOfProgress: goalDaysOfProgress[goal.id]?? 0,
                            progress: goalProgress[goal.id] ?? 0.0,
                          );
                        }),
                        const SizedBox(height: 40),
                        GeneralChart(
                             goalNames: goalNames,
                             goalProgress: goalProgress
                         ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    for (Goal goal in goalList) {
      int daysOfProgress = await dashboardService
          .calculateDaysOfProgress(goal.id); // Aguarda o cálculo do progresso

      double percentualProgress = await dashboardService.calculateGoalProgress(
          daysOfProgress, goal.targetPercentage);

      // Adiciona o progresso e o nome da meta no mapa
      goalNames[goal.id] = goal.name;
      goalDaysOfProgress[goal.id] = daysOfProgress;
      goalProgress[goal.id] = percentualProgress;

    }
  }
}
