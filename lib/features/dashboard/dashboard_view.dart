import 'package:flutter/material.dart';
import 'package:skillforge/app/routes.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('climbly · dashboard')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        children: const [
          _NavTile(label: 'Skill Mapper', route: AppRoutes.skillMapper),
          _NavTile(label: 'Career Paths', route: AppRoutes.careerPaths),
          _NavTile(label: 'Learning Plan', route: AppRoutes.learningPlan),
          _NavTile(label: 'Advisor Chat', route: AppRoutes.advisorChat),
          _NavTile(label: 'Mock Interview', route: AppRoutes.mockInterview),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String label;
  final String route;
  const _NavTile({required this.label, required this.route});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Center(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}


