import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/features/home/home_view.dart';
import 'package:skillforge/features/advisor/modern_advisor_view.dart';
import 'package:skillforge/features/settings/settings_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const ModernAdvisorView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.house()),
              activeIcon: PhosphorIcon(PhosphorIcons.house()),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.chatCircle()),
              activeIcon: PhosphorIcon(PhosphorIcons.chatCircle()),
              label: 'Advisor',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.gear()),
              activeIcon: PhosphorIcon(PhosphorIcons.gear()),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
