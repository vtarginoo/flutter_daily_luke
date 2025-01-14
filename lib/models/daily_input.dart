class DailyInput {
  final String id; // ID único baseado em metaId e actionDate
  final int goalId; // Relaciona o input com a meta correspondente
  final DateTime actionDate; // Data do registro da ação
  final DateTime updateDate; // Data de criação ou atualização do registro
  bool input; // Indica se a meta foi cumprida (Sim/Não)

  DailyInput({
    required this.id,
    required this.goalId,
    required this.actionDate,
    required this.updateDate,
    required this.input,
  });

  // Função para gerar o ID único baseado em metaId e actionDate
  static String generateId(String metaId, DateTime actionDate) {
    return '${metaId}-${actionDate.toIso8601String().split("T")[0]}'; // Exemplo: 'meta123-2025-01-10'
  }

  // Setter e Getter para garantir a conversão de 0/1
  set inputAsInt(int value) {
    input = value == 1; // 1 vira true, 0 vira false
  }

  int get inputAsInt {
    return input ? 1 : 0; // true vira 1, false vira 0
  }


  // Método para converter o objeto para um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_id': goalId,
      'action_date': actionDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
      'input': input ? 1 : 0, // Converte o booleano para 1 ou 0
    };
  }

  // Método para criar o objeto a partir do mapa
  factory DailyInput.fromMap(Map<String, dynamic> map) {
    return DailyInput(
      id: map['id'],
      goalId: map['goal_id'],
      actionDate: DateTime.parse(map['action_date']),
      updateDate: DateTime.parse(map['update_date']),
      input: map['input'] == 1, // Converte o 1 ou 0 de volta para booleano
    );
  }

  @override
  String toString() {
    return 'DailyInput{id: $id, goalId: $goalId, actionDate: $actionDate, updateDate: $updateDate, input: $input}';
  }
}
