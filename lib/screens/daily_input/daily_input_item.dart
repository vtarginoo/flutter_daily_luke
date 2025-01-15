import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/util/date_time_helper.dart';
import 'package:daily_luke/models/daily_input.dart';
import 'package:daily_luke/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyInputItem extends StatefulWidget {
  final DateTime date;

  const DailyInputItem({Key? key, required this.date}) : super(key: key);

  @override
  _DailyInputItemState createState() => _DailyInputItemState();
}

class _DailyInputItemState extends State<DailyInputItem> {
  late Future<List<Goal>> _goalsFuture;
  late Map<int, bool>
      _goalStates; // Armazena o estado de cada meta (Sim ou Não)

  @override
  void initState() {
    super.initState();
    _goalsFuture = _fetchGoals();
    _goalStates = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Metas: ${DateFormat('dd/MM/yyyy').format(widget.date)}",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Goal>>(
        future: _goalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final goals = snapshot.data ?? [];
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];

              return ListTile(
                title: Text(goal.name),
                trailing: Switch(
                  value: _goalStates[goal.id] ?? false,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _goalStates[goal.id] = value;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveInputs,
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<List<Goal>> _fetchGoals() async {
    final db = await DailyInputDao().getDailyDB();

    // Busca todas as metas
    final result = await db.rawQuery('SELECT * FROM goals ORDER BY id');
    final goals = result.map((row) {
      return Goal(
        row['id'] as int,
        name: row['name'] as String,
        targetPercentage: row['target_percentage'] as double,
        createdDate: DateTime.parse(row['created_date'] as String),
      );
    }).toList();

    // Busca os estados salvos (inputs diários) para a data específica
    final dailyInputsResult = await db.rawQuery(
      'SELECT goal_id, input FROM daily_inputs WHERE action_date = ?',
      [DateTimeHelper.removeTime(widget.date).toIso8601String()],
    );

    // Cria um mapa de estados salvos
    final Map<int, bool> savedStates = {
      for (var row in dailyInputsResult)
        row['goal_id'] as int: (row['input'] as int) == 1,
    };

    // Atualiza _goalStates com os estados salvos ou default (false)
    for (final goal in goals) {
      _goalStates[goal.id] = savedStates[goal.id] ?? false;
    }

    return goals;
  }

  Future<void> _saveInputs() async {
    final dao = DailyInputDao();

    // Data atual para atualização
    final DateTime now = DateTime.now();

    // Zera a hora da data de ação
    final DateTime actionDate = DateTimeHelper.removeTime(widget.date);

    // Itera pelas metas e cria objetos DailyInput
    final List<DailyInput> dailyInputs = _goalStates.entries.map((entry) {
      final goal_id = entry.key;
      final isCompleted = entry.value;
      print("Printou aqui é false");

      return DailyInput(
        id: DailyInput.generateId(goal_id.toString(), widget.date),
        // ID único
        goalId: goal_id,
        actionDate: actionDate,
        // Data de referência
        updateDate: now,
        // Momento do salvamento
        input: isCompleted, // Estado (Sim/Não)
      );
    }).toList();

    // Salva os registros no banco
    for (final dailyInput in dailyInputs) {
      await dao.save(dailyInput);
    }

    // Volta para a tela anterior
    Navigator.pop(context, true); // Indica que houve alteração
  }
}
