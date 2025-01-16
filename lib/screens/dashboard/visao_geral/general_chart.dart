import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GeneralChart extends StatefulWidget {
  final Map<int, double> goalProgress; // Mapa de ID -> Progresso
  final Map<int, String> goalNames;  // Mapa de IDs para nomes das metas

  const GeneralChart({
    super.key,
    required this.goalProgress,
    required this.goalNames,
  });

  @override
  State<GeneralChart> createState() => GeneralChartState();
}

class GeneralChartState extends State<GeneralChart> {
  late List<BarChartGroupData> barGroups; // Lista que armazenará as barras do gráfico

  @override
  void initState() {
    super.initState();
    // Inicializa o gráfico diretamente com os dados recebidos
    _prepareChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: BarChart(
        BarChartData(
          maxY: 100, // Garante que o gráfico vá até 100
          minY: 0,
          barGroups: barGroups, // Usa as barras geradas diretamente
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40, // Espaço
                showTitles: true,
                interval: 20, // Frequência de exibição dos títulos
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toStringAsFixed(0)}%', // Exibe o número sem decimais
                    style: const TextStyle(fontSize: 16), // Ajusta o tamanho da fonte
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 50, // Espaço reservado para o rótulo
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final goalName = widget.goalNames[value.toInt()] ?? ''; // Nome da meta
                  return Text(
                    goalName, // Exibe o nome da meta
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  // Método para montar as barras com base nos parâmetros recebidos
  void _prepareChartData() {
    List<BarChartGroupData> newBarGroups = [];

    widget.goalProgress.forEach((goalId, progress) {
      final goalName = widget.goalNames[goalId] ?? '';

      // Define a cor com base nas novas regras de progresso
      Color barColor;
      if (progress >= 100) {
        barColor = Colors.green; // 100% ou mais
      } else if (progress >= 90 && progress < 100) {
        barColor = Colors.yellow; // Entre 90% e 99%
      } else {
        barColor = Colors.red; // Abaixo de 90%
      }

      // Adiciona a barra correspondente
      newBarGroups.add(
        BarChartGroupData(
          x: goalId,
          barRods: [
            BarChartRodData(
              toY: progress,
              color: barColor,
              borderRadius: BorderRadius.zero,
              width: 22,
              backDrawRodData: BackgroundBarChartRodData(
                toY: 100, // Valor máximo do gráfico
                color: Colors.grey[300]!,
              ),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    });

    setState(() {
      barGroups = newBarGroups;
    });
  }

}



