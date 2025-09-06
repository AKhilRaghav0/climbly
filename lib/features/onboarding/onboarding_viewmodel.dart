import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skillforge/models/user_data.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  
  int _currentPage = 0;
  bool _isLoading = false;
  
  // Form data
  String _name = '';
  String _currentRole = '';
  List<String> _skills = [];
  List<String> _interests = [];
  String _experienceLevel = '';
  List<String> _targetRoles = [];
  String _timeHorizon = '';

  // Getters
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get canProceed => _validateCurrentPage();
  bool get isLastPage => _currentPage == 3;
  
  String get name => _name;
  String get currentRole => _currentRole;
  List<String> get skills => _skills;
  List<String> get interests => _interests;
  String get experienceLevel => _experienceLevel;
  List<String> get targetRoles => _targetRoles;
  String get timeHorizon => _timeHorizon;

  // Setters
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set currentRole(String value) {
    _currentRole = value;
    notifyListeners();
  }

  set experienceLevel(String value) {
    _experienceLevel = value;
    notifyListeners();
  }

  set timeHorizon(String value) {
    _timeHorizon = value;
    notifyListeners();
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      _skills.add(skill);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }

  void addInterest(String interest) {
    if (interest.isNotEmpty && !_interests.contains(interest)) {
      _interests.add(interest);
      notifyListeners();
    }
  }

  void removeInterest(String interest) {
    _interests.remove(interest);
    notifyListeners();
  }

  void addTargetRole(String role) {
    if (role.isNotEmpty && !_targetRoles.contains(role)) {
      _targetRoles.add(role);
      notifyListeners();
    }
  }

  void removeTargetRole(String role) {
    _targetRoles.remove(role);
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 3) {
      debugPrint('➡️ Moving to page ${_currentPage + 1}');
      _currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    } else {
      debugPrint('⚠️ Already on last page');
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      debugPrint('⬅️ Moving to page ${_currentPage - 1}');
      _currentPage--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    } else {
      debugPrint('⚠️ Already on first page');
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _name.isNotEmpty && _currentRole.isNotEmpty;
      case 1:
        return _skills.isNotEmpty && _interests.isNotEmpty;
      case 2:
        return _experienceLevel.isNotEmpty && _timeHorizon.isNotEmpty;
      case 3:
        return _targetRoles.isNotEmpty;
      default:
        return false;
    }
  }

  UserData buildUserData() {
    debugPrint('🏗️ Building user data:');
    debugPrint('   Name: $_name');
    debugPrint('   Role: $_currentRole');
    debugPrint('   Skills: ${_skills.length} items');
    debugPrint('   Interests: ${_interests.length} items');
    debugPrint('   Experience: $_experienceLevel');
    debugPrint('   Target Roles: ${_targetRoles.length} items');
    debugPrint('   Time Horizon: $_timeHorizon');
    
    return UserData(
      name: _name,
      currentRole: _currentRole,
      skills: _skills,
      interests: _interests,
      experienceLevel: _experienceLevel,
      targetRoles: _targetRoles,
      timeHorizon: _timeHorizon,
      isOnboarded: true,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
