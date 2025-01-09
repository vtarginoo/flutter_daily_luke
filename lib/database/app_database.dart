import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


 Future<Database> getDatabase() async {
   final String path = join(await getDatabasesPath(), 'dailyluke.db');
   return openDatabase(
     path,
     onCreate: (db, version) {
       db.execute(GoalDao.tableSql);
     },
     version: 1,
   );
 }
