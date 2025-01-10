class DailyInput {
  final int id; // Identificador único do input
  final int goalId; // Relaciona o input com a meta correspondente
  final DateTime date; // Data do registro
  final bool value; // Indica se a meta foi cumprida (Sim/Não)

  DailyInput({
    required this.id,
    required this.goalId,
    required this.date,
    required this.value,
  });

  @override
  String toString() {
    return 'DailyInput{id: $id, goalId: $goalId, date: $date, value: $value}';
  }
}
