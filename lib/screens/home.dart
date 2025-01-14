import 'package:daily_luke/component/home_components/custom_inkwell.dart';
import 'package:daily_luke/screens/daily_input/daily_input_list.dart';
import 'package:daily_luke/screens/dashboard/dashboard_screen.dart';

import 'package:daily_luke/screens/goals/goals_list.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Luke",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Adicionando a imagem acima dos InkWells
            Image.asset(
              'assets/images/luke1.jpg',
              // Caminho da imagem no diretório "assets"
              height: screenHeight * 0.4, // Tamanho da imagem
              fit: BoxFit.cover, // Ajuste de como a imagem se encaixa
            ),
            const SizedBox(height: 16.0), // Espaço entre a imagem e os InkWells
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomInkwell(
                    title: 'Metas',
                    icon: Icons.flag,
                    onTap: () {
                      // Navegue ou execute uma ação
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GoalsList()));
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomInkwell(
                    title: 'Daily Input',
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DailyInputList()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CustomInkwell(
              title: 'Dashboard',
              icon: Icons.dashboard,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
