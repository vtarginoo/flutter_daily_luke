import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:daily_luke/service/dashboard_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GeneralChart extends StatefulWidget {
  @override
  State<GeneralChart> createState() => GeneralChartState();
}

class GeneralChartState extends State<GeneralChart> {
  List<BarChartGroupData> barGroups = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();  // Carregar dados ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                   //drawBelowEverything: true,
                  sideTitles: SideTitles(
                    reservedSize: 40, //Espaço
                    showTitles: true,
                    interval: 20, // Define a frequência de exibição dos títulos
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0), // Exibe o número sem decimais
                        style: TextStyle(
                            fontSize: 16), // Ajusta o tamanho da fonte
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        );
  }
  // Função para carregar dados do banco de dados e atualizar o gráfico
  Future<void> _loadChartData() async {
    final dashboardService = DashboardService();
    final goalDao = GoalDao();

    // Recupera todas as metas (aguarda o Future ser resolvido)
    final List<Goal> goals = await goalDao.findAll();

    // Recupera a frequência dos inputs (metas alcançadas) para cada meta
    List<BarChartGroupData> newBarGroups = [];
    for (Goal goal in goals) {
      double frequency = await dashboardService.calculateGoalProgress(goal.id);
      print(frequency); ///////// Problema está aqui temos que rever!!!!!!


      // Adiciona a frequência da meta ao gráfico
      newBarGroups.add(
        BarChartGroupData(x: goal.id, barRods: [
          BarChartRodData(toY: frequency), // O valor da barra corresponde à frequência
        ]),
      );
    }

    setState(() {
      barGroups = newBarGroups; // Atualiza a lista de barras
    });
    print(barGroups);
  }
}



