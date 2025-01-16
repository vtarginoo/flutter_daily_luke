import 'package:daily_luke/models/goal.dart';
import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final int diasAteHoje;
  final Goal goal;
  final int daysOfProgress;
  final double progress;

  const GeneralCard({
    Key? key,
    required this.diasAteHoje,
    required this.goal,
    required this.daysOfProgress,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinando a cor de fundo do card com base no percentual atingido
    Color backgroundColor = Colors.grey.shade100; // Cor padrão enquanto espera

    // Atualiza a cor de fundo com base no percentual
    if (progress >= 100) {
      backgroundColor = Colors.green.shade100;
    } else if (progress >= 100 - 10) {
      backgroundColor = Colors.yellow.shade100;
    } else {
      backgroundColor = Colors.red.shade100;
    }

    int meta =  ((goal.targetPercentage/100) * diasAteHoje).toInt();



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
              value: progress / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 100 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // Cards com Meta/Realizado (%)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          '$daysOfProgress dias / $meta dias',
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
                          '${progress.toStringAsFixed(2)}% / 100%',
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
