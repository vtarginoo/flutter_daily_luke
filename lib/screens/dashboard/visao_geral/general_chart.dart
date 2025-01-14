import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GeneralChart extends StatefulWidget {
  GeneralChart({super.key});

  @override
  State<StatefulWidget> createState() => GeneralChartState();
}

class GeneralChartState extends State<GeneralChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,  // Ajustado para aumentar a altura e largura do gráfico
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Metas Semanais',
                  style: TextStyle(
                    color: Colors.black,  // Alterado para preto
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Comparação entre metas e resultados diários',
                  style: TextStyle(
                    color: Colors.black87,  // Alterado para um tom mais neutro
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 38,
                ),
                // Gráfico de barras com metas
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],  // Adicionado fundo delimitador
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26),  // Borda fina
                      ),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        duration: animDuration,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Novo gráfico de linha ou outra visualização pode ser adicionado aqui
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      refreshState();
                    }
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  BarChartGroupData makeGroupData(
      int x,
      double realValue,
      double targetValue, {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    barColor ??= Colors.white;
    return BarChartGroupData(
      x: x,
      barRods: [
        // Barra para o valor real alcançado
        BarChartRodData(
          toY: realValue,
          color: Colors.green,
          width: width,
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
        // Barra para a meta (target)
        BarChartRodData(
          toY: targetValue,
          color: Colors.yellow,
          width: width,
          borderSide: BorderSide(color: Colors.yellow.shade700),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(3, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, 6, isTouched: i == touchedIndex); // Real e Meta
      case 1:
        return makeGroupData(1, 6.5, 7, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, 6, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  // Função para gerar dados fictícios (substitua com dados reais conforme necessário)
  BarChartData randomData() {
    return BarChartData(
      barGroups: showingGroups(),
    );
  }

  // Função para gerar os dados principais do gráfico (substitua conforme necessário)
  BarChartData mainBarData() {
    return BarChartData(
      barGroups: showingGroups(),
    );
  }

  // Função para atualizar o estado do gráfico
  void refreshState() {
    setState(() {});
  }
}