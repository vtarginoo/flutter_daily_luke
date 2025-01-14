import 'package:sqflite/sqflite.dart';

import '../../models/daily_input.dart';
import '../app_database.dart';

class DailyInputDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id TEXT PRIMARY KEY, ' // O ID agora é um String, gerado com base no goalId e actionDate
      '$_goalId INTEGER, '
      '$_actionDate TEXT, ' // actionDate armazenada como string (ISO 8601)
      '$_updateDate TEXT, ' // updateDate armazenada como string (ISO 8601)
      '$_input INTEGER, ' // O campo input é um valor booleano armazenado como INTEGER (0 ou 1)
      'FOREIGN KEY($_goalId) REFERENCES goals($_id))';
  static const String _tableName = 'daily_inputs';
  static const String _id = 'id';
  static const String _goalId = 'goal_id';
  static const String _actionDate = 'action_date';
  static const String _updateDate = 'update_date';
  static const String _input = 'input';

  Future<Database> getDailyDB() async {
    return await getDatabase();
  }

  // Método para salvar ou atualizar o DailyInput
  Future<int> save(DailyInput dailyInput) async {
    final db = await getDailyDB(); // Obtém a instância do banco de dados

    // Insere ou substitui o registro no banco, usando o ID único
    return db.insert(
      _tableName, // Nome da tabela
      dailyInput.toMap(),
      // Converte o DailyInput para Map (preparando para salvar no banco)
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Substitui registros com o mesmo ID
    );
  }

  Future<List<DailyInput>> findAll() async {
    final Database db = getDailyDB() as Database;
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<DailyInput> dailyInputs = _toList(result);
    return dailyInputs;
  }

  // Método para limpar a tabela (truncate)
  Future<void> truncate() async {
    final Database db = await getDailyDB();
    await db.delete(_tableName); // Deleta todos os registros da tabela
  }

  // Método para recuperar os inputs de uma data específica
  Future<List<DailyInput>> getDailyInputsByDate(DateTime date) async {
    final db = await getDailyDB(); // Obtém a instância do banco de dados

    // Formata a data para pegar somente a parte da data (sem hora)
    final formattedDate = date.toIso8601String().split('T')[0];

    // Consulta os registros para a data fornecida
    final result = await db.query(
      _tableName, // Nome da tabela
      where: 'action_date LIKE ?', // Filtra pelos registros que têm a mesma data
      whereArgs: ['${formattedDate}%'], // Adiciona o filtro da data
    );

    // Converte o resultado em uma lista de DailyInput
    return result.map((map) => DailyInput.fromMap(map)).toList();
  }

// Conversão do DailyInput para um Map para inserir no banco de dados
  Map<String, dynamic> _toMap(DailyInput dailyInput) {
    final Map<String, dynamic> inputMap = {};
    inputMap[_id] = dailyInput.id;
    inputMap[_goalId] = dailyInput.goalId;
    inputMap[_actionDate] = dailyInput.actionDate
        .toIso8601String(); // actionDate como string (ISO 8601)
    inputMap[_updateDate] = dailyInput.updateDate
        .toIso8601String(); // updateDate como string (ISO 8601)
    inputMap[_input] = dailyInput.input
        ? 1
        : 0; // Convertendo o booleano para 1 (true) ou 0 (false)
    return inputMap;
  }

  // Conversão da lista de Map para a lista de DailyInput
  List<DailyInput> _toList(List<Map<String, dynamic>> result) {
    final List<DailyInput> dailyInputs = [];
    for (Map<String, dynamic> row in result) {
      final DailyInput input = DailyInput(
        id: row[_id],
        goalId: row[_goalId],
        actionDate: DateTime.parse(row[_actionDate]),
        // Convertendo a string de volta para DateTime
        updateDate: DateTime.parse(row[_updateDate]),
        // Convertendo a string de volta para DateTime
        input: row[_input] == 1, // Interpretando 1 como true e 0 como false
      );
      dailyInputs.add(input);
    }
    return dailyInputs;
  }
}
