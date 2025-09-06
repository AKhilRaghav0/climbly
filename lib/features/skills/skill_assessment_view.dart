import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/features/skills/skill_assessment_viewmodel.dart';

class SkillAssessmentView extends StatefulWidget {
  const SkillAssessmentView({super.key});

  @override
  State<SkillAssessmentView> createState() => _SkillAssessmentViewState();
}

class _SkillAssessmentViewState extends State<SkillAssessmentView> {
  late SkillAssessmentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillAssessmentViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skill Assessment'),
          actions: [
            Consumer<SkillAssessmentViewModel>(
              builder: (context, viewModel, child) {
                return TextButton(
                  onPressed: viewModel.canAssess ? _runAssessment : null,
                  child: const Text('Assess'),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: ClimblyTheme.subtleGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildContent(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                'Skill Assessment',
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
          'Let\'s evaluate your current skills and identify areas for growth',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ClimblyTheme.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<SkillAssessmentViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.assessmentResult != null) {
          return _buildResults(context, viewModel.assessmentResult!);
        }

        return _buildSkillInput(context, viewModel);
      },
    );
  }

  Widget _buildSkillInput(BuildContext context, SkillAssessmentViewModel viewModel) {
    return Column(
      children: [
        _buildCurrentSkills(context, viewModel),
        const SizedBox(height: 24),
        _buildAddSkill(context, viewModel),
      ],
    );
  }

  Widget _buildCurrentSkills(BuildContext context, SkillAssessmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Skills',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        if (viewModel.skills.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ClimblyTheme.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ClimblyTheme.grayLight),
            ),
            child: Column(
              children: [
                PhosphorIcon(
                  PhosphorIcons.star(),
                  color: ClimblyTheme.gray,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'No skills added yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ClimblyTheme.gray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your skills below to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClimblyTheme.grayLight,
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: viewModel.skills.map((skill) => _buildSkillChip(skill, () => viewModel.removeSkill(skill))).toList(),
          ),
      ],
    );
  }

  Widget _buildSkillChip(String skill, VoidCallback onRemove) {
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
            skill,
            style: const TextStyle(
              color: ClimblyTheme.cream,
              fontWeight: FontWeight.w500,
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

  Widget _buildAddSkill(BuildContext context, SkillAssessmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Skills',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: viewModel.skillController,
                decoration: InputDecoration(
                  hintText: 'e.g., Python, React, Machine Learning',
                  prefixIcon: PhosphorIcon(PhosphorIcons.plus()),
                ),
                onSubmitted: (value) => viewModel.addSkill(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: viewModel.canAddSkill ? viewModel.addSkill : null,
              child: PhosphorIcon(PhosphorIcons.plus()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSuggestedSkills(context, viewModel),
      ],
    );
  }

  Widget _buildSuggestedSkills(BuildContext context, SkillAssessmentViewModel viewModel) {
    final suggestedSkills = [
      'Python', 'JavaScript', 'React', 'Node.js', 'SQL',
      'Machine Learning', 'Data Analysis', 'UI/UX Design',
      'Project Management', 'Communication', 'Leadership'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Skills',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestedSkills.map((skill) => _buildSuggestedChip(skill, viewModel)).toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestedChip(String skill, SkillAssessmentViewModel viewModel) {
    final isSelected = viewModel.skills.contains(skill);
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          viewModel.removeSkill(skill);
        } else {
          viewModel.addSkillFromSuggestion(skill);
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
          skill,
          style: TextStyle(
            color: isSelected ? ClimblyTheme.cream : ClimblyTheme.charcoal,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, String result) {
    return SingleChildScrollView(
      child: Container(
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
                PhosphorIcon(
                  PhosphorIcons.chartBar(),
                  color: ClimblyTheme.charcoal,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Assessment Results',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ClimblyTheme.charcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              result,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ClimblyTheme.charcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runAssessment() async {
    final userProvider = context.read<UserProvider>();
    await _viewModel.runAssessment(userProvider.userData);
  }
}
