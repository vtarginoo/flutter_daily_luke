import 'package:daily_luke/models/goal.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';

class GoalDao {

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_percent REAL)';
  static const String _tableName = 'goals';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _percent = 'percent';

  Future<int> save(Goal goal) async {
    final Database db = await getDatabase();
    Map<String, dynamic> goalMap = _toMap(goal);
    return db.insert(_tableName, goalMap);
  }

  Future<List<Goal>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Goal> goal = _toList(result);
    return goal;
  }

  Map<String, dynamic> _toMap(Goal goal) {
    final Map<String, dynamic> goalMap = {};
    goalMap[_name] = goal.name;
    goalMap[_percent] = goal.percent;
    return goalMap;
  }

  List<Goal> _toList(List<Map<String, dynamic>> result) {
    final List<Goal> goals = [];
    for (Map<String, dynamic> row in result) {
      final Goal goal = Goal(
        row[_id],
        name:row[_name],
        percent:row[_percent],
      );
      goals.add(goal);
    }
    return goals;
  }
}