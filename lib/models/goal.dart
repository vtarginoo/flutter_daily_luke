class Goal {
  final int id;
  final String name;
  final double percent;

  Goal(this.id, {required this.name, required this.percent});

  @override
  String toString() {
    return 'Goal{id: $id, name: $name, percent: $percent}';
  }


}