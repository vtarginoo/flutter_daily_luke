import 'package:sqflite/sqflite.dart';

import '../../models/daily_input.dart';
import '../app_database.dart';

class DailyInputDao {

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_goalId INTEGER, '
      '$_date TEXT, '  // A data será armazenada como uma string (ISO 8601)
      '$_value INTEGER, '  // Valor booleano armazenado como INTEGER (0 ou 1)
      'FOREIGN KEY($_goalId) REFERENCES goals($_id))';
  static const String _tableName = 'daily_inputs';
  static const String _id = 'id';
  static const String _goalId = 'goal_id';
  static const String _date = 'date';
  static const String _value = 'value';

  Future<int> save(DailyInput dailyInput) async {
    final Database db = await getDatabase();
    Map<String, dynamic> inputMap = _toMap(dailyInput);
    return db.insert(_tableName, inputMap);
  }

  Future<List<DailyInput>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<DailyInput> dailyInputs = _toList(result);
    return dailyInputs;
  }

  Map<String, dynamic> _toMap(DailyInput dailyInput) {
    final Map<String, dynamic> inputMap = {};
    inputMap[_goalId] = dailyInput.goalId;
    inputMap[_date] = dailyInput.date.toIso8601String(); // Convertendo DateTime para string (ISO 8601)
    inputMap[_value] = dailyInput.value ? 1 : 0; // Convertendo o valor booleano para 1 (true) ou 0 (false)
    return inputMap;
  }

  List<DailyInput> _toList(List<Map<String, dynamic>> result) {
    final List<DailyInput> dailyInputs = [];
    for (Map<String, dynamic> row in result) {
      final DailyInput input = DailyInput(
        id: row[_id],
        goalId: row[_goalId],
        date: DateTime.parse(row[_date]), // Convertendo a string de volta para DateTime
        value: row[_value] == 1, // Interpretando 1 como true e 0 como false
      );
      dailyInputs.add(input);
    }
    return dailyInputs;
  }
}