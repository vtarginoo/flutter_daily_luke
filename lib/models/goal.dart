class Goal {
  final int id;
  final String name;
  final double targetPercentage;
  final DateTime createdDate;

  Goal(this.id,
      {required this.name,
      required this.targetPercentage,
      DateTime? createdDate})
      : createdDate = createdDate ?? DateTime.now();

  /// Método para criar um `Goal` a partir de um `Map`
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      map['id'] as int, // Converte o campo 'id' para int
      name: map['name'] as String, // Converte o campo 'name' para String
      targetPercentage: map['target_percentage'] as double, // Converte o campo 'target_percentage' para double
      createdDate: DateTime.parse(map['created_date'] as String), // Converte o campo 'created_date' para DateTime
    );
  }

  @override
  String toString() {
    return 'Goal{id: $id, name: $name, targetPercentage: $targetPercentage, createdDate: $createdDate}';
  }
}
