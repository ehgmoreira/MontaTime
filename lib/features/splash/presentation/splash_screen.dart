import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // Controlador do fade-in inicial
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🌀 Animação Lottie centralizada
            Center(
              child: Lottie.asset(
                'assets/animations/sports_intro.json',
                fit: BoxFit.contain,
                repeat: false,
                onLoaded: (composition) {
                  // Quando a Lottie terminar, navega automaticamente
                  Future.delayed(composition.duration, () {
                    if (mounted) context.go('/players');
                  });
                },
              ),
            ),

            // 🏷️ Texto animado na parte inferior
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Text(
                  'Monta Times ⚡',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 1200.ms, delay: 1200.ms)
                    .slideY(begin: 1, end: 0, duration: 800.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
