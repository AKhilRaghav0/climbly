import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/features/onboarding/onboarding_viewmodel.dart';

class OnboardingPage4 extends StatefulWidget {
  const OnboardingPage4({super.key});

  @override
  State<OnboardingPage4> createState() => _OnboardingPage4State();
}

class _OnboardingPage4State extends State<OnboardingPage4> {
  final TextEditingController _roleController = TextEditingController();

  @override
  void dispose() {
    _roleController.dispose();
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
                PhosphorIcons.target(),
                color: ClimblyTheme.cream,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Target Roles',
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
          'What roles are you aiming for?',
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
            _buildRoleInput(viewModel),
            const SizedBox(height: 20),
            _buildSuggestedRoles(),
            const SizedBox(height: 20),
            _buildSelectedRoles(viewModel),
          ],
        );
      },
    );
  }

  Widget _buildRoleInput(OnboardingViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _roleController,
            decoration: InputDecoration(
              hintText: 'e.g., Senior Software Engineer',
              prefixIcon: PhosphorIcon(PhosphorIcons.plus()),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                viewModel.addTargetRole(value);
                _roleController.clear();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_roleController.text.isNotEmpty) {
              viewModel.addTargetRole(_roleController.text);
              _roleController.clear();
            }
          },
          child: PhosphorIcon(PhosphorIcons.plus()),
        ),
      ],
    );
  }

  Widget _buildSuggestedRoles() {
    final suggestedRoles = [
      'Software Engineer',
      'Data Scientist',
      'Product Manager',
      'UX Designer',
      'DevOps Engineer',
      'Machine Learning Engineer',
      'Frontend Developer',
      'Backend Developer',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Roles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestedRoles.map((role) => _buildSuggestedChip(role)).toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestedChip(String role) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        final isSelected = viewModel.targetRoles.contains(role);
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              viewModel.removeTargetRole(role);
            } else {
              viewModel.addTargetRole(role);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? ClimblyTheme.charcoal : ClimblyTheme.cream,
              border: Border.all(
                color: isSelected ? ClimblyTheme.charcoal : ClimblyTheme.grayLight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role,
              style: TextStyle(
                color: isSelected ? ClimblyTheme.cream : ClimblyTheme.charcoal,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedRoles(OnboardingViewModel viewModel) {
    if (viewModel.targetRoles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Roles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.targetRoles.map((role) => _buildSelectedChip(role, () => viewModel.removeTargetRole(role))).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedChip(String text, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ClimblyTheme.charcoal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: ClimblyTheme.cream,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child:             PhosphorIcon(
              PhosphorIcons.x(),
              size: 16,
              color: ClimblyTheme.cream,
            ),
          ),
        ],
      ),
    );
  }
}
