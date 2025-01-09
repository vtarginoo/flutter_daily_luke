import 'package:daily_luke/models/goal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase(){
 return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'dailyluke.db');
   return openDatabase(path, onCreate: (db,version){
      db.execute('CREATE TABLE goals('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'percent REAL)');
    }, version: 1);
  });
}


Future<int> save (Goal goal) {
  return createDatabase().then((db) {
    final Map<String, dynamic> goalMap = {};
    goalMap['name'] = goal.name;
    goalMap['percent'] = goal.percent;
   return db.insert('goals', goalMap);
  });
}

Future<List<Goal>> findAll() {
  return createDatabase().then((db) {
    return db.query('goals').then((maps) {
      final List<Goal> goals = [];
      for (Map<String, dynamic> map in maps) {
        final Goal contact = Goal(
          map['id'],
          name: map['name'],
          percent: map['percent'],
        );
        goals.add(contact);
      }
      return goals;
    });
  });
}