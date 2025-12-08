import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Added for context.go()
import '../../widgets/curved_header.dart';
import '../../theme/theme.dart';
import '../../state/auth_providers.dart';
import '../../state/biometric_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pop(context);
                  context.go('/login');
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      );
    }

    void showBiometricDialog(bool value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Biometric'),
          content: Text('Are you sure you want to ${value ? 'enable' : 'disable'} biometric unlock?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(biometricEnabledProvider.notifier).toggle(value);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurvedHeader(
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => context.go('/home'), // Navigate to DashboardScreen
                            tooltip: 'Back to Dashboard',
                          ),
                          const Icon(Icons.person_rounded, color: Colors.white, size: 48, semanticLabel: 'Profile Icon'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.person_outline, color: AppColors.primary),
                              title: const Text('Full Name'),
                              subtitle: Text(authState.name ?? 'Not set'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                              title: const Text('Email'),
                              subtitle: Text(authState.email ?? 'Not set'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                              title: const Text('Phone'),
                              subtitle: Text(authState.phone ?? 'Not set'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                              title: const Text('Date of Birth'),
                              subtitle: Text(authState.dob?.split('T')[0] ?? 'Not set'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => context.go('/settings'),
                              child: const Text('Edit Profile', style: TextStyle(color: AppColors.primary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!kIsWeb)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Security Settings',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              SwitchListTile(
                                title: const Text('Enable Biometric Unlock'),
                                subtitle: const Text('Use fingerprint or face recognition'),
                                value: biometricEnabled,
                                onChanged: (value) => showBiometricDialog(value),
                                activeThumbColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go('/change-password'),
                                child: const Text('Change Password', style: TextStyle(color: AppColors.primary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account Actions',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: showLogoutDialog,
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text('Log Out'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => context.go('/delete-account'),
                              child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}