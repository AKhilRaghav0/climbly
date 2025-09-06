import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/providers/theme_provider.dart';
import 'package:skillforge/features/onboarding/onboarding_view.dart';
import 'package:skillforge/features/main/main_navigation.dart';

class ClimblyApp extends StatelessWidget {
  const ClimblyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'climbly',
            debugShowCheckedModeBanner: false,
            theme: ClimblyTheme.build(isDark: false),
            darkTheme: ClimblyTheme.build(isDark: true),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AppWrapper(),
          );
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    debugPrint('🚀 AppWrapper initializing...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('📱 Loading user data on app start');
      context.read<UserProvider>().loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        debugPrint('🔄 AppWrapper rebuild - Loading: ${userProvider.isLoading}, Onboarded: ${userProvider.isOnboarded}');
        
        if (userProvider.isLoading) {
          debugPrint('⏳ Showing loading screen');
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!userProvider.isOnboarded) {
          debugPrint('📝 Showing onboarding flow');
          return const OnboardingView();
        }

        debugPrint('🏠 Showing main navigation');
        return const MainNavigation();
      },
    );
  }
}


