import 'dart:async';

import 'package:daily_luke/models/goal.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';

class GoalDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_targetPercentage REAL, '
      '$_createdDate TEXT)';  // Campo de data de criação

  static const String _tableName = 'goals';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _targetPercentage = 'target_percentage';
  static const String _createdDate = 'created_date';

  Future<Database> getGoalDatabase () async{
   return await getDatabase();
  }



  Future<int> save(Goal goal) async {
    final Database db = await getGoalDatabase ();
    Map<String, dynamic> goalMap = _toMap(goal);
    return db.insert(_tableName, goalMap);
  }

  Future<List<Goal>> findAll() async {
    final Database db = await getGoalDatabase ();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Goal> goals = _toList(result);
    return goals;
  }

  // Método para limpar a tabela (truncate)
  Future<void> truncate() async {
    final Database db = await getGoalDatabase ();
    await db.delete(_tableName); // Deleta todos os registros da tabela
  }

  Future<void> dropTable() async {
    final Database db = await getGoalDatabase ();
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }

  Future<void> recreateTable() async {
    final Database db = await getGoalDatabase ();
    await db.execute(GoalDao.tableSql);
  }

  Map<String, dynamic> _toMap(Goal goal) {
    final Map<String, dynamic> goalMap = {};
    goalMap[_name] = goal.name;
    goalMap[_targetPercentage] = goal.targetPercentage;
    goalMap[_createdDate] = goal.createdDate.toIso8601String();  // Converte para string ISO 8601
    return goalMap;
  }

  List<Goal> _toList(List<Map<String, dynamic>> result) {
    final List<Goal> goals = [];
    for (Map<String, dynamic> row in result) {
      final Goal goal = Goal(
        row[_id],
        name: row[_name],
        targetPercentage: row[_targetPercentage],
        createdDate: DateTime.parse(row[_createdDate]),  // Converte a string de volta para DateTime
      );
      goals.add(goal);
    }
    return goals;
  }
}