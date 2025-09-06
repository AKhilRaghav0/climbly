import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/features/skills/skill_assessment_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                    _buildHeader(context, userProvider.userData.name),
                    const SizedBox(height: 32),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildRecentActivity(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: ClimblyTheme.gray,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          name.isNotEmpty ? name : 'there',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: ClimblyTheme.charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to climb higher in your career?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ClimblyTheme.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildActionCard(
              context,
              'Skill Assessment',
              PhosphorIcons.star(),
              ClimblyTheme.charcoal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SkillAssessmentView()),
              ),
            ),
            _buildActionCard(
              context,
              'Career Paths',
              PhosphorIcons.ladder(),
              ClimblyTheme.gray,
              () {},
            ),
            _buildActionCard(
              context,
              'Learning Plan',
              PhosphorIcons.book(),
              ClimblyTheme.gray,
              () {},
            ),
            _buildActionCard(
              context,
              'Mock Interview',
              PhosphorIcons.chatCircle(),
              ClimblyTheme.gray,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ClimblyTheme.cream,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PhosphorIcon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ClimblyTheme.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
                PhosphorIcon(
                  PhosphorIcons.clock(),
                  color: ClimblyTheme.gray,
                  size: 32,
                ),
              const SizedBox(height: 12),
              Text(
                'No recent activity',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ClimblyTheme.gray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Start exploring to see your progress here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ClimblyTheme.grayLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
