class UserData {
  final String name;
  final String currentRole;
  final List<String> skills;
  final List<String> interests;
  final String experienceLevel;
  final List<String> targetRoles;
  final String timeHorizon;
  final bool isOnboarded;

  const UserData({
    required this.name,
    required this.currentRole,
    required this.skills,
    required this.interests,
    required this.experienceLevel,
    required this.targetRoles,
    required this.timeHorizon,
    this.isOnboarded = false,
  });

  UserData copyWith({
    String? name,
    String? currentRole,
    List<String>? skills,
    List<String>? interests,
    String? experienceLevel,
    List<String>? targetRoles,
    String? timeHorizon,
    bool? isOnboarded,
  }) {
    return UserData(
      name: name ?? this.name,
      currentRole: currentRole ?? this.currentRole,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      targetRoles: targetRoles ?? this.targetRoles,
      timeHorizon: timeHorizon ?? this.timeHorizon,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentRole': currentRole,
      'skills': skills,
      'interests': interests,
      'experienceLevel': experienceLevel,
      'targetRoles': targetRoles,
      'timeHorizon': timeHorizon,
      'isOnboarded': isOnboarded,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      currentRole: json['currentRole'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      experienceLevel: json['experienceLevel'] ?? '',
      targetRoles: List<String>.from(json['targetRoles'] ?? []),
      timeHorizon: json['timeHorizon'] ?? '',
      isOnboarded: json['isOnboarded'] ?? false,
    );
  }

  static const UserData empty = UserData(
    name: '',
    currentRole: '',
    skills: [],
    interests: [],
    experienceLevel: '',
    targetRoles: [],
    timeHorizon: '',
    isOnboarded: false,
  );
}
