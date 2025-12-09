import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/state/auth_providers.dart';
import '../../theme/theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      final onboardingCompleted = await ref.read(onboardingCompletedProvider.future);

      if (!mounted) return;
      // The main router now handles redirection based on auth state.
      // We just need to decide if we show onboarding or go to the main app flow.
      if (onboardingCompleted) {
        context.go('/login'); // Go to login, router will redirect to /home if logged in
      } else { 
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/vector.png', width: 280, height: 120),
            const SizedBox(height: 24),
            const Text('myMicroBiz', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
