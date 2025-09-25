// screens/security_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/security.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final settings = provider.securitySettings.first;
        final events = provider.securityEvents;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Security'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Status
                _buildSecurityStatus(settings),
                const SizedBox(height: 24),

                // Security Settings
                Text(
                  'Security Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildSecuritySettings(settings),
                const SizedBox(height: 24),

                // Recent Activity
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildSecurityEvents(events),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityStatus(SecuritySettings settings) {
    final isSecure = settings.isSecure;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isSecure ? Icons.security : Icons.warning,
                  color: isSecure ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSecure ? 'Account is Secure' : 'Security Improvements Needed',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSecure
                            ? 'All security features are enabled'
                            : 'Enable 2FA and data encryption for better security',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings(SecuritySettings settings) {
    return Column(
      children: [
        Builder(
          builder: (context) => _buildSettingTile(
            'Two-Factor Authentication',
            settings.twoFactorEnabled ? 'Enabled' : 'Disabled',
            settings.twoFactorEnabled ? Icons.check_circle : Icons.warning,
            settings.twoFactorEnabled ? Colors.green : Colors.orange,
            onTap: () => _navigateTo2FASettings(context),
          ),
        ),
        Builder(
          builder: (context) => _buildSettingTile(
            'Biometric Authentication',
            settings.biometricEnabled ? 'Enabled' : 'Disabled',
            settings.biometricEnabled ? Icons.fingerprint : Icons.close,
            settings.biometricEnabled ? Colors.green : Colors.grey,
            onTap: () => _navigateToBiometricSettings(context),
          ),
        ),
        Builder(
          builder: (context) => _buildSettingTile(
            'Session Timeout',
            '${settings.sessionTimeoutMinutes} minutes',
            Icons.timer,
            Colors.blue,
            onTap: () => _navigateToSessionSettings(context),
          ),
        ),
        Builder(
          builder: (context) => _buildSettingTile(
            'Data Encryption',
            settings.dataEncryptionEnabled ? 'Enabled' : 'Disabled',
            Icons.lock,
            settings.dataEncryptionEnabled ? Colors.green : Colors.red,
            onTap: () => _navigateToEncryptionSettings(context),
          ),
        ),
        Builder(
          builder: (context) => _buildSettingTile(
            'Login Notifications',
            settings.loginNotifications ? 'Enabled' : 'Disabled',
            Icons.notifications,
            settings.loginNotifications ? Colors.green : Colors.grey,
            onTap: () => _navigateToNotificationSettings(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(value),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSecurityEvents(List<SecurityEvent> events) {
    if (events.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No recent security events'),
        ),
      );
    }

    return Column(
      children: events.map((event) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: event.eventColor.withOpacity(0.1),
              child: Icon(event.eventIcon, color: event.eventColor),
            ),
            title: Text(event.description),
            subtitle: Text(
              '${event.timestamp.day}/${event.timestamp.month}/${event.timestamp.year} at ${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}',
            ),
            trailing: event.requiresAction
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Action Required',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  void _navigateTo2FASettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Two-Factor Authentication'),
          content: const Text('2FA settings would be implemented here. This would include enabling/disabling 2FA, setting up authenticator apps, and managing backup codes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToBiometricSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometric Authentication'),
          content: const Text('Biometric settings would be implemented here. This would include enabling/disabling fingerprint/face unlock and managing biometric preferences.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSessionSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Session Timeout Settings'),
          content: const Text('Session settings would be implemented here. This would include configuring automatic logout times and session management preferences.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEncryptionSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Encryption Settings'),
          content: const Text('Encryption settings would be implemented here. This would include data encryption preferences and security configurations.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Notification Settings'),
          content: const Text('Notification settings would be implemented here. This would include configuring login alerts and security notification preferences.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}