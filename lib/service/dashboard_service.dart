import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';
import 'package:daily_luke/models/daily_input.dart';
import 'package:daily_luke/models/goal.dart';

class DashboardService {
  static final DateTime now = DateTime.now();
  static final DateTime startOfYear = DateTime(now.year, 1, 1);
  static final int daysElapsed = now.difference(startOfYear).inDays + 1;

  final GoalDao goalDao = GoalDao();
  final DailyInputDao dailyInputDao = DailyInputDao();

  Future<List<DailyInput>> findAllDailyInput() {
    return dailyInputDao.findAll();
  }

  Future<List<Goal>> findAllGoal() {
    return GoalDao().findAll();
  }

  Future<int> calculateDaysOfProgress(int goalId) async {
    // Obtém a meta pelo ID
    final goal = await goalDao.findById(goalId);
    if (goal == null) {
      throw Exception("Meta não encontrada.");
    }
    // Dias realizados no ano vigente
    final completedDays =
        await dailyInputDao.countCompletedDaysSince(goalId, startOfYear);

    return completedDays;

  }

  Future<double> calculateGoalProgress(
      int completedDays, double targetPercentage) async {
    // Calcula a porcentagem de progresso
    final progress = (completedDays / (targetPercentage * daysElapsed)) * 10000;

    // Formata o progresso para 2 casas decimais e retorna
    return double.parse(progress.toStringAsFixed(2)).clamp(0.0, 100.0);
  }
}
