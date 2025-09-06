import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/features/onboarding/onboarding_viewmodel.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  @override
  void dispose() {
    _skillController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 32),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
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
                PhosphorIcons.star(),
                color: ClimblyTheme.cream,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Your Skills & Interests',
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
          'What are you good at and what excites you?',
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
            _buildSkillSection(viewModel),
            const SizedBox(height: 24),
            _buildInterestSection(viewModel),
          ],
        );
      },
    );
  }

  Widget _buildSkillSection(OnboardingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  hintText: 'Add a skill',
                  prefixIcon: PhosphorIcon(PhosphorIcons.plus()),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    viewModel.addSkill(value);
                    _skillController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_skillController.text.isNotEmpty) {
                  viewModel.addSkill(_skillController.text);
                  _skillController.clear();
                }
              },
              child: PhosphorIcon(PhosphorIcons.plus()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.skills.map((skill) => _buildChip(skill, () => viewModel.removeSkill(skill))).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestSection(OnboardingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _interestController,
                decoration: InputDecoration(
                  hintText: 'Add an interest',
                  prefixIcon: PhosphorIcon(PhosphorIcons.plus()),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    viewModel.addInterest(value);
                    _interestController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_interestController.text.isNotEmpty) {
                  viewModel.addInterest(_interestController.text);
                  _interestController.clear();
                }
              },
              child: PhosphorIcon(PhosphorIcons.plus()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.interests.map((interest) => _buildChip(interest, () => viewModel.removeInterest(interest))).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String text, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ClimblyTheme.cream,
        border: Border.all(color: ClimblyTheme.grayLight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child:             PhosphorIcon(
              PhosphorIcons.x(),
              size: 16,
              color: ClimblyTheme.gray,
            ),
          ),
        ],
      ),
    );
  }
}
