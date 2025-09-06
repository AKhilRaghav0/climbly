import 'package:flutter/foundation.dart';

abstract class ViewModel extends ChangeNotifier {
  bool _busy = false;
  bool get isBusy => _busy;
  Future<T> runBusy<T>(Future<T> Function() task) async {
    _busy = true;
    notifyListeners();
    try {
      return await task();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}

class DashboardViewModel extends ViewModel {}
class SkillMapperViewModel extends ViewModel {}
class CareerPathsViewModel extends ViewModel {}
class LearningPlanViewModel extends ViewModel {}
class AdvisorChatViewModel extends ViewModel {}
class MockInterviewViewModel extends ViewModel {}



