import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, Map<String, double>>((ref) {
  return BudgetNotifier();
});

class BudgetNotifier extends StateNotifier<Map<String, double>> {
  static const String _limitKey = 'budget_limit';
  static const String _spentKey = 'budget_spent';
  static const String _monthKey = 'budget_month';

  BudgetNotifier() : super({'limit': 0.0, 'spent': 0.0}) {
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final currentMonth = DateTime.now().month;
    final savedMonth = prefs.getInt(_monthKey) ?? 0;

    if (savedMonth != currentMonth) {
      // Reset for new month
      await prefs.setDouble(_limitKey, 0.0);
      await prefs.setDouble(_spentKey, 0.0);
      await prefs.setInt(_monthKey, currentMonth);
    }

    state = {
      'limit': prefs.getDouble(_limitKey) ?? 0.0,
      'spent': prefs.getDouble(_spentKey) ?? 0.0,
    };
  }

  void setLimit(double limit) async {
    state = {...state, 'limit': limit};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_limitKey, limit);
  }

  void addSpent(double amount) async {
    state = {...state, 'spent': (state['spent'] ?? 0.0) + amount};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_spentKey, state['spent']!);
  }

  double getProgress() => state['limit']! > 0 ? state['spent']! / state['limit']! : 0.0;
}