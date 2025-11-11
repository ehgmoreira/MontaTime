import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/player/presentation/player_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: TeamBalancerApp()));
}

class TeamBalancerApp extends StatelessWidget {
  const TeamBalancerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/players', builder: (_, __) => const PlayerListScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'Monta Time',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
