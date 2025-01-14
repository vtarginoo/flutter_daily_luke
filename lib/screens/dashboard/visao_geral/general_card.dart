import 'package:daily_luke/models/daily_input.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final Goal goal;
  final int diasAteHoje;
  final List<DailyInput> inputList;

  const GeneralCard({
    Key? key,
    required this.goal,
    required this.diasAteHoje,
    required this.inputList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double metaEmDias = diasAteHoje * (goal.targetPercentage / 100);
    final int atingimento =
        inputList.where((input) => input.goalId == goal.id).length;
    final double percentualAtingido = (atingimento / metaEmDias) * 100;

    // Determinando a cor de fundo do card com base no percentual atingido
    Color backgroundColor;
    if (percentualAtingido >= goal.targetPercentage) {
      backgroundColor = Colors.green.shade100;
    } else if (percentualAtingido >= goal.targetPercentage - 5) {
      backgroundColor = Colors.yellow.shade100;
    } else {
      backgroundColor = Colors.red.shade100;
    }

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Barra de Progresso Linear
            LinearProgressIndicator(
              value: percentualAtingido / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                  percentualAtingido >= goal.targetPercentage
                      ? Colors.green
                      : Colors.red),
            ),
            const SizedBox(height: 20),

            // Cards com Meta/Realizado (%)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Percentual
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado Dias',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$atingimento dias / ${metaEmDias.toStringAsFixed(0)} dias',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Card Dias
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado (%)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${percentualAtingido.toStringAsFixed(2)}% / ${goal.targetPercentage.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
