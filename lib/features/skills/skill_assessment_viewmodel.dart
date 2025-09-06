import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skillforge/services/gemini_service.dart';
import 'package:skillforge/models/user_data.dart';

class SkillAssessmentViewModel extends ChangeNotifier {
  final TextEditingController skillController = TextEditingController();
  final List<String> _skills = [];
  bool _isLoading = false;
  String? _assessmentResult;

  List<String> get skills => _skills;
  bool get isLoading => _isLoading;
  String? get assessmentResult => _assessmentResult;
  bool get canAddSkill => skillController.text.trim().isNotEmpty;
  bool get canAssess => _skills.isNotEmpty;

  void addSkill() {
    final skill = skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      debugPrint('➕ Adding skill: $skill');
      _skills.add(skill);
      skillController.clear();
      notifyListeners();
    } else {
      debugPrint('⚠️ Skill not added - empty or duplicate: $skill');
    }
  }

  void addSkillFromSuggestion(String skill) {
    if (!_skills.contains(skill)) {
      debugPrint('➕ Adding suggested skill: $skill');
      _skills.add(skill);
      notifyListeners();
    } else {
      debugPrint('⚠️ Suggested skill already exists: $skill');
    }
  }

  void removeSkill(String skill) {
    debugPrint('➖ Removing skill: $skill');
    _skills.remove(skill);
    notifyListeners();
  }

  Future<void> runAssessment(UserData userData) async {
    debugPrint('🔍 Starting skill assessment for: ${userData.name}');
    debugPrint('🛠️ Skills to assess: ${_skills.join(', ')}');
    
    _isLoading = true;
    notifyListeners();

    try {
      final result = await GeminiService.generateSkillAssessment(
        userData: userData,
        currentSkills: _skills,
      );
      _assessmentResult = result;
      debugPrint('✅ Skill assessment completed successfully');
    } catch (e) {
      debugPrint('❌ Error in skill assessment: $e');
      _assessmentResult = 'Sorry, there was an error running the assessment. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _assessmentResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }
}
