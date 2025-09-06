import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/providers/theme_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: ClimblyTheme.subtleGradient,
        ),
        child: SafeArea(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildUserInfo(context, userProvider.userData),
                    const SizedBox(height: 24),
                    _buildSettingsOptions(context),
                    const Spacer(),
                    _buildLogoutButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ClimblyTheme.charcoal,
            borderRadius: BorderRadius.circular(12),
          ),
          child:         PhosphorIcon(
          PhosphorIcons.gear(),
          color: ClimblyTheme.cream,
          size: 24,
        ),
        ),
        const SizedBox(width: 16),
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, userData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClimblyTheme.cream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ClimblyTheme.charcoal.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ClimblyTheme.charcoal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:                 PhosphorIcon(
                  PhosphorIcons.user(),
                  color: ClimblyTheme.charcoal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.name.isNotEmpty ? userData.name : 'User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ClimblyTheme.charcoal,
                      ),
                    ),
                    Text(
                      userData.currentRole.isNotEmpty ? userData.currentRole : 'No role specified',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ClimblyTheme.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Experience Level', userData.experienceLevel.isNotEmpty ? userData.experienceLevel : 'Not specified'),
          _buildInfoRow(context, 'Target Roles', userData.targetRoles.isNotEmpty ? userData.targetRoles.join(', ') : 'None selected'),
          _buildInfoRow(context, 'Time Horizon', userData.timeHorizon.isNotEmpty ? userData.timeHorizon : 'Not specified'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ClimblyTheme.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ClimblyTheme.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(context, [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildSettingsItem(
                context,
                'Dark Mode',
                themeProvider.isDarkMode ? PhosphorIcons.moon() : PhosphorIcons.sun(),
                () {
                  themeProvider.toggleTheme();
                },
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            'Edit Profile',
            PhosphorIcons.user(),
            () {},
          ),
          _buildSettingsItem(
            context,
            'Notification Settings',
            PhosphorIcons.bell(),
            () {},
          ),
          _buildSettingsItem(
            context,
            'Privacy & Security',
            PhosphorIcons.lock(),
            () {},
          ),
          _buildSettingsItem(
            context,
            'Help & Support',
            PhosphorIcons.question(),
            () {},
          ),
        ]),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ClimblyTheme.cream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ClimblyTheme.charcoal.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      leading: PhosphorIcon(
        icon,
        color: ClimblyTheme.charcoal,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: ClimblyTheme.charcoal,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? PhosphorIcon(
        PhosphorIcons.caretRight(),
        color: ClimblyTheme.gray,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await context.read<UserProvider>().clearUserData();
        },
        icon: PhosphorIcon(PhosphorIcons.signOut()),
        label: const Text('Reset Profile'),
        style: ElevatedButton.styleFrom(
          backgroundColor: ClimblyTheme.grayLight,
          foregroundColor: ClimblyTheme.cream,
        ),
      ),
    );
  }
}
