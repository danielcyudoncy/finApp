// models/user.dart

enum UserRole {
  free,
  premium,
  admin,
}

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final DateTime createdDate;
  final DateTime lastLogin;
  final UserRole role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? profileImageUrl;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> settings;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.createdDate,
    required this.lastLogin,
    this.role = UserRole.free,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.profileImageUrl,
    this.preferences = const {},
    this.settings = const {},
  });

  // Helper methods
  String get fullName => '$firstName $lastName';
  bool get isPremium => role == UserRole.premium;
  bool get isAdmin => role == UserRole.admin;

  // Get preference value with default
  T? getPreference<T>(String key, T defaultValue) {
    return preferences[key] ?? defaultValue;
  }

  // Get setting value with default
  T? getSetting<T>(String key, T defaultValue) {
    return settings[key] ?? defaultValue;
  }

  // Create a copy with modified fields
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? createdDate,
    DateTime? lastLogin,
    UserRole? role,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdDate: createdDate ?? this.createdDate,
      lastLogin: lastLogin ?? this.lastLogin,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      settings: settings ?? this.settings,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'createdDate': createdDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'role': role.index,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences,
      'settings': settings,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      createdDate: DateTime.parse(json['createdDate']),
      lastLogin: DateTime.parse(json['lastLogin']),
      role: UserRole.values[json['role']],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      preferences: json['preferences'] ?? {},
      settings: json['settings'] ?? {},
    );
  }
}