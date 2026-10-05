import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: PunctualColors.deepAccent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: PunctualColors.border,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                size: 46,
                color: PunctualColors.softHighlight,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Administrator',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(height: 6),

            Text(
              'Punctual Admin',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(height: 32),

            _ProfileInfoTile(
              icon: Icons.badge_outlined,
              title: 'Role',
              value: 'Administrator',
            ),

            const SizedBox(height: 12),

            _ProfileInfoTile(
              icon: Icons.access_time_rounded,
              title: 'System',
              value: 'Punctual Attendance',
            ),

            const SizedBox(height: 12),

            _ProfileInfoTile(
              icon: Icons.security_outlined,
              title: 'Access',
              value: 'Full Management Access',
            ),

            const SizedBox(height: 32),

            _ProfileActionTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Application preferences',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Settings will be available here.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _ProfileActionTile(
              icon: Icons.info_outline_rounded,
              title: 'About Punctual',
              subtitle: 'Attendance management system',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Punctual',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.access_time_rounded,
                    color: PunctualColors.primary,
                    size: 32,
                  ),
                  children: const [
                    Text(
                      'A simple attendance management '
                      'application for students and administrators.',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      PunctualColors.critical,
                  side: const BorderSide(
                    color: PunctualColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: PunctualColors.deepAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: PunctualColors.softHighlight,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PunctualColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: PunctualColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: PunctualColors.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: PunctualColors.secondaryText,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: PunctualColors.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}