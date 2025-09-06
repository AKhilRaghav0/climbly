import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_data.dart';

class UserProvider extends ChangeNotifier {
  UserData _userData = UserData.empty;
  bool _isLoading = false;

  UserData get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isOnboarded => _userData.isOnboarded;

  Future<void> loadUserData() async {
    debugPrint('📱 Loading user data...');
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString('user_data');
      
      if (userDataJson != null) {
        debugPrint('📄 Found saved user data');
        final userDataMap = json.decode(userDataJson) as Map<String, dynamic>;
        _userData = UserData.fromJson(userDataMap);
        debugPrint('✅ User data loaded: ${_userData.name} (${_userData.isOnboarded ? 'onboarded' : 'not onboarded'})');
      } else {
        debugPrint('📭 No saved user data found');
      }
    } catch (e) {
      debugPrint('❌ Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserData(UserData userData) async {
    debugPrint('💾 Saving user data for: ${userData.name}');
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = json.encode(userData.toJson());
      await prefs.setString('user_data', userDataJson);
      
      _userData = userData;
      debugPrint('✅ User data saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(UserData userData) async {
    await saveUserData(userData);
  }

  Future<void> completeOnboarding(UserData userData) async {
    debugPrint('🎉 Completing onboarding for: ${userData.name}');
    final completedUserData = userData.copyWith(isOnboarded: true);
    await saveUserData(completedUserData);
    debugPrint('✅ Onboarding completed successfully');
  }

  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      _userData = UserData.empty;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
}
