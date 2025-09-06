import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/features/onboarding/onboarding_viewmodel.dart';
import 'package:skillforge/features/onboarding/widgets/onboarding_page1.dart';
import 'package:skillforge/features/onboarding/widgets/onboarding_page2.dart';
import 'package:skillforge/features/onboarding/widgets/onboarding_page3.dart';
import 'package:skillforge/features/onboarding/widgets/onboarding_page4.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: ClimblyTheme.subtleGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView(
                    controller: _viewModel.pageController,
                    children: const [
                      OnboardingPage1(),
                      OnboardingPage2(),
                      OnboardingPage3(),
                      OnboardingPage4(),
                    ],
                  ),
                ),
                _buildNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Welcome to Climbly',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ClimblyTheme.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s set up your personalized career journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ClimblyTheme.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (viewModel.currentPage > 0)
                TextButton.icon(
                  onPressed: viewModel.previousPage,
                  icon: PhosphorIcon(PhosphorIcons.arrowLeft()),
                  label: const Text('Back'),
                )
              else
                const SizedBox(width: 80),
              
              _buildPageIndicator(),
              
              if (viewModel.isLastPage)
                ElevatedButton.icon(
                  onPressed: viewModel.canProceed ? _completeOnboarding : null,
                  icon: PhosphorIcon(PhosphorIcons.check()),
                  label: const Text('Get Started'),
                )
              else
                ElevatedButton.icon(
                  onPressed: viewModel.canProceed ? viewModel.nextPage : null,
                  icon: PhosphorIcon(PhosphorIcons.arrowRight()),
                  label: const Text('Next'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= viewModel.currentPage
                    ? ClimblyTheme.charcoal
                    : ClimblyTheme.grayLight,
              ),
            );
          }),
        );
      },
    );
  }

  void _completeOnboarding() async {
    final userData = _viewModel.buildUserData();
    await context.read<UserProvider>().completeOnboarding(userData);
  }
}


