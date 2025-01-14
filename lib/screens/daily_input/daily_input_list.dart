import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/screens/daily_input/daily_input_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyInputList extends StatefulWidget {
  const DailyInputList({Key? key}) : super(key: key);

  @override
  State<DailyInputList> createState() => _DailyInputListState();
}

class _DailyInputListState extends State<DailyInputList> {
  @override
  Widget build(BuildContext context) {
    final DateTime startDate = DateTime(DateTime.now().year, 1, 1);
    final DateTime endDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Inputs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Set<DateTime>>(
        future: _fetchCompletedDates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final Set<DateTime> completedDates = snapshot.data ?? {};

          return ListView.builder(
            itemCount: endDate.difference(startDate).inDays + 1,
            itemBuilder: (context, index) {
              final DateTime currentDate = DateTime(
                endDate.year,
                endDate.month,
                endDate.day,
              ).subtract(Duration(days: index));
              final String formattedDate =
                  DateFormat('dd/MM/yyyy').format(currentDate);
              final bool isCompleted = completedDates.contains(currentDate);

              return ListTile(
                leading: Icon(
                  isCompleted
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                  color: isCompleted ? Colors.green : Colors.red,
                ),
                title: Text(formattedDate),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _navigateToDayInput(context, currentDate);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Set<DateTime>> _fetchCompletedDates() async {
    final db = await DailyInputDao().getDailyDB();

    // Consulta para buscar as datas já registradas no formato 'YYYY-MM-DD'
    final result = await db.rawQuery('''
    SELECT DISTINCT strftime('%Y-%m-%d', action_date) AS action_date
    FROM daily_inputs
  ''');

    // Converte cada linha em um objeto DateTime normalizado
    return result.map((row) {
      final DateTime parsedDate = DateTime.parse(row['action_date'] as String);
      // Retorna o DateTime normalizado para ano, mês e dia (hora zerada)
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    }).toSet();
  }

  void _navigateToDayInput(BuildContext context, DateTime date) async {
    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyInputItem(date: date),
      ),
    );

    // Recarregar os dados caso tenha ocorrido uma alteração
    if (isUpdated == true) {
      setState(() {
        _fetchCompletedDates(); // Recarrega os dados do banco
      });
    }
  }
}
