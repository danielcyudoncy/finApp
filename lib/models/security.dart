// models/security.dart
import 'package:flutter/material.dart';

enum SecurityEventType {
  login,
  logout,
  passwordChange,
  failedLogin,
  suspiciousActivity,
  dataExport,
  accountDeletion,
  permissionChange,
}

enum TwoFactorMethod {
  sms,
  email,
  authenticator,
  biometric,
}

class SecuritySettings {
  final String userId;
  final bool twoFactorEnabled;
  final TwoFactorMethod? twoFactorMethod;
  final bool biometricEnabled;
  final bool sessionTimeoutEnabled;
  final int sessionTimeoutMinutes;
  final bool loginNotifications;
  final bool dataEncryptionEnabled;
  final bool screenLockEnabled;
  final List<String> trustedDevices;
  final DateTime lastUpdated;

  SecuritySettings({
    required this.userId,
    this.twoFactorEnabled = false,
    this.twoFactorMethod,
    this.biometricEnabled = false,
    this.sessionTimeoutEnabled = true,
    this.sessionTimeoutMinutes = 30,
    this.loginNotifications = true,
    this.dataEncryptionEnabled = true,
    this.screenLockEnabled = false,
    this.trustedDevices = const [],
    required this.lastUpdated,
  });

  bool get isSecure => twoFactorEnabled && dataEncryptionEnabled;

  SecuritySettings copyWith({
    String? userId,
    bool? twoFactorEnabled,
    TwoFactorMethod? twoFactorMethod,
    bool? biometricEnabled,
    bool? sessionTimeoutEnabled,
    int? sessionTimeoutMinutes,
    bool? loginNotifications,
    bool? dataEncryptionEnabled,
    bool? screenLockEnabled,
    List<String>? trustedDevices,
    DateTime? lastUpdated,
  }) {
    return SecuritySettings(
      userId: userId ?? this.userId,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorMethod: twoFactorMethod ?? this.twoFactorMethod,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      sessionTimeoutEnabled: sessionTimeoutEnabled ?? this.sessionTimeoutEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      loginNotifications: loginNotifications ?? this.loginNotifications,
      dataEncryptionEnabled: dataEncryptionEnabled ?? this.dataEncryptionEnabled,
      screenLockEnabled: screenLockEnabled ?? this.screenLockEnabled,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'twoFactorEnabled': twoFactorEnabled,
      'twoFactorMethod': twoFactorMethod?.index,
      'biometricEnabled': biometricEnabled,
      'sessionTimeoutEnabled': sessionTimeoutEnabled,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'loginNotifications': loginNotifications,
      'dataEncryptionEnabled': dataEncryptionEnabled,
      'screenLockEnabled': screenLockEnabled,
      'trustedDevices': trustedDevices,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      userId: json['userId'],
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      twoFactorMethod: json['twoFactorMethod'] != null
          ? TwoFactorMethod.values[json['twoFactorMethod']]
          : null,
      biometricEnabled: json['biometricEnabled'] ?? false,
      sessionTimeoutEnabled: json['sessionTimeoutEnabled'] ?? true,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] ?? 30,
      loginNotifications: json['loginNotifications'] ?? true,
      dataEncryptionEnabled: json['dataEncryptionEnabled'] ?? true,
      screenLockEnabled: json['screenLockEnabled'] ?? false,
      trustedDevices: List<String>.from(json['trustedDevices'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class SecurityEvent {
  final String id;
  final String userId;
  final SecurityEventType type;
  final DateTime timestamp;
  final String description;
  final String? ipAddress;
  final String? deviceInfo;
  final String? location;
  final bool requiresAction;

  SecurityEvent({
    required this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    required this.description,
    this.ipAddress,
    this.deviceInfo,
    this.location,
    this.requiresAction = false,
  });

  IconData get eventIcon {
    switch (type) {
      case SecurityEventType.login:
        return Icons.login;
      case SecurityEventType.logout:
        return Icons.logout;
      case SecurityEventType.passwordChange:
        return Icons.password;
      case SecurityEventType.failedLogin:
        return Icons.warning;
      case SecurityEventType.suspiciousActivity:
        return Icons.error;
      case SecurityEventType.dataExport:
        return Icons.download;
      case SecurityEventType.accountDeletion:
        return Icons.delete_forever;
      case SecurityEventType.permissionChange:
        return Icons.admin_panel_settings;
    }
  }

  Color get eventColor {
    switch (type) {
      case SecurityEventType.login:
      case SecurityEventType.logout:
        return Colors.green;
      case SecurityEventType.passwordChange:
        return Colors.blue;
      case SecurityEventType.failedLogin:
      case SecurityEventType.suspiciousActivity:
        return Colors.red;
      case SecurityEventType.dataExport:
        return Colors.orange;
      case SecurityEventType.accountDeletion:
        return Colors.red;
      case SecurityEventType.permissionChange:
        return Colors.purple;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
      'location': location,
      'requiresAction': requiresAction,
    };
  }

  factory SecurityEvent.fromJson(Map<String, dynamic> json) {
    return SecurityEvent(
      id: json['id'],
      userId: json['userId'],
      type: SecurityEventType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      ipAddress: json['ipAddress'],
      deviceInfo: json['deviceInfo'],
      location: json['location'],
      requiresAction: json['requiresAction'] ?? false,
    );
  }
}

class PrivacySettings {
  final String userId;
  final bool profileVisible;
  final bool financialDataVisible;
  final bool activityVisible;
  final bool allowDataCollection;
  final bool allowPersonalizedAds;
  final bool allowThirdPartySharing;
  final List<String> dataRetentionPreferences;
  final DateTime lastUpdated;

  PrivacySettings({
    required this.userId,
    this.profileVisible = false,
    this.financialDataVisible = false,
    this.activityVisible = false,
    this.allowDataCollection = true,
    this.allowPersonalizedAds = false,
    this.allowThirdPartySharing = false,
    this.dataRetentionPreferences = const [],
    required this.lastUpdated,
  });

  PrivacySettings copyWith({
    String? userId,
    bool? profileVisible,
    bool? financialDataVisible,
    bool? activityVisible,
    bool? allowDataCollection,
    bool? allowPersonalizedAds,
    bool? allowThirdPartySharing,
    List<String>? dataRetentionPreferences,
    DateTime? lastUpdated,
  }) {
    return PrivacySettings(
      userId: userId ?? this.userId,
      profileVisible: profileVisible ?? this.profileVisible,
      financialDataVisible: financialDataVisible ?? this.financialDataVisible,
      activityVisible: activityVisible ?? this.activityVisible,
      allowDataCollection: allowDataCollection ?? this.allowDataCollection,
      allowPersonalizedAds: allowPersonalizedAds ?? this.allowPersonalizedAds,
      allowThirdPartySharing: allowThirdPartySharing ?? this.allowThirdPartySharing,
      dataRetentionPreferences: dataRetentionPreferences ?? this.dataRetentionPreferences,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profileVisible': profileVisible,
      'financialDataVisible': financialDataVisible,
      'activityVisible': activityVisible,
      'allowDataCollection': allowDataCollection,
      'allowPersonalizedAds': allowPersonalizedAds,
      'allowThirdPartySharing': allowThirdPartySharing,
      'dataRetentionPreferences': dataRetentionPreferences,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      userId: json['userId'],
      profileVisible: json['profileVisible'] ?? false,
      financialDataVisible: json['financialDataVisible'] ?? false,
      activityVisible: json['activityVisible'] ?? false,
      allowDataCollection: json['allowDataCollection'] ?? true,
      allowPersonalizedAds: json['allowPersonalizedAds'] ?? false,
      allowThirdPartySharing: json['allowThirdPartySharing'] ?? false,
      dataRetentionPreferences: List<String>.from(json['dataRetentionPreferences'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}