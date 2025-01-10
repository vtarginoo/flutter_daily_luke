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

  @override
  String toString() {
    return 'Goal{id: $id, name: $name, targetPercentage: $targetPercentage, createdDate: $createdDate}';
  }
}
