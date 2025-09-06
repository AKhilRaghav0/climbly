import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/features/onboarding/onboarding_viewmodel.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

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
                PhosphorIcons.ladder(),
                color: ClimblyTheme.cream,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Experience & Timeline',
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
          'Help us understand your current level and goals',
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
            _buildExperienceSection(context, viewModel),
            const SizedBox(height: 24),
            _buildTimelineSection(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildExperienceSection(BuildContext context, OnboardingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience Level',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        ...['Beginner', 'Intermediate', 'Advanced', 'Expert'].map((level) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RadioListTile<String>(
              title: Text(level),
              value: level,
              groupValue: viewModel.experienceLevel,
              onChanged: (value) => viewModel.experienceLevel = value ?? '',
              activeColor: ClimblyTheme.charcoal,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTimelineSection(BuildContext context, OnboardingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Horizon',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        ...['3 months', '6 months', '1 year', '2+ years'].map((timeline) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RadioListTile<String>(
              title: Text(timeline),
              value: timeline,
              groupValue: viewModel.timeHorizon,
              onChanged: (value) => viewModel.timeHorizon = value ?? '',
              activeColor: ClimblyTheme.charcoal,
            ),
          );
        }).toList(),
      ],
    );
  }
}
