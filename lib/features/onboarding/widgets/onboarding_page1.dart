import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/features/onboarding/onboarding_viewmodel.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildTitle(context),
          const SizedBox(height: 32),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ClimblyTheme.charcoal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: PhosphorIcon(
                PhosphorIcons.user(),
                color: ClimblyTheme.cream,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ClimblyTheme.charcoal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ll use this information to personalize your career journey',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ClimblyTheme.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            TextField(
              onChanged: (value) => viewModel.name = value,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your full name',
                  prefixIcon: PhosphorIcon(PhosphorIcons.user()),
                ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => viewModel.currentRole = value,
              decoration: InputDecoration(
                labelText: 'Current Role',
                hintText: 'e.g., Student, Software Developer, Designer',
                prefixIcon: PhosphorIcon(PhosphorIcons.briefcase()),
              ),
            ),
          ],
        );
      },
    );
  }
}
