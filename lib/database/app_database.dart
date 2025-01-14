import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


 Future<Database> getDatabase() async {
   final String path = join(await getDatabasesPath(), 'dailyluke.db');

   return openDatabase(
     path,
     onCreate: (db, version) async {
       await db.execute(GoalDao.tableSql);

       await db.execute(DailyInputDao.tableSql);

     },
     version: 1,
   );
 }

Future<void> deleteDatabaseFile() async {
  try {
    final String path = join(await getDatabasesPath(), 'dailyluke.db');
    await deleteDatabase(path);
    print("Banco de dados deletado com sucesso.");
  } catch (e) {
    print("Erro ao deletar o banco de dados: $e");
  }
}
