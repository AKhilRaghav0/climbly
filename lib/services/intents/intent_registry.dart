typedef IntentHandler = Future<String> Function(Map<String, dynamic>);

class IntentRegistry {
  IntentRegistry._();
  static final Map<String, IntentHandler> _handlers = {
    'map_skills': _stub,
    'recommend_paths': _stub,
    'draft_learning_plan': _stub,
    'answer_career_question': _stub,
    'simulate_interview': _stub,
  };

  static Future<String> handle(String intent, Map<String, dynamic> payload) async {
    final handler = _handlers[intent];
    if (handler == null) return 'Unknown intent: $intent';
    return handler(payload);
  }

  static Future<String> _stub(Map<String, dynamic> payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return 'stub-response';
  }
}



