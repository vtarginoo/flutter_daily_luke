import 'package:daily_luke/database/dao/daily_input_dao.dart';
import 'package:daily_luke/database/dao/goal_dao.dart';

class DashboardService {
  final GoalDao goalDao = GoalDao();
  final DailyInputDao dailyInputDao = DailyInputDao();

  Future<double> calculateGoalProgress(int goalId) async {
    // Obtém a meta pelo ID
    final goal = await goalDao.findById(goalId);
    if (goal == null) {
      throw Exception("Meta não encontrada.");
    }

    // Dados da meta
    final targetPercentage = goal.targetPercentage;
    final createdDate = goal.createdDate;

    // Data atual e início do ano
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);

    // Dias passados no ano atual
    final daysElapsed = now.difference(startOfYear).inDays + 1;

    // Dias realizados desde a data de criação
    final completedDays =
        await dailyInputDao.countCompletedDaysSince(goalId, createdDate);

    // Evita divisão por zero no targetPercentage
    if (targetPercentage == 0) return 0.0;

    // Calcula a porcentagem de progresso
    final progress = (completedDays / (targetPercentage * daysElapsed)) * 100;

    return progress.clamp(
        0.0, 100.0); // Garante que o valor esteja entre 0% e 100%
  }
}
