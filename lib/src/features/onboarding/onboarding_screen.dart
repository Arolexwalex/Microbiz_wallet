import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../state/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Take Full Control\nof Your Business Finances',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Record Sales & Expenses\nEffortlessly',
      'image': 'assets/images/onboarding2.jpg',
    },
    {
      'title': 'Grow Your Business\nwith Smart Insights',
      'image': 'assets/images/onboarding3.png', // Add your third image22
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            // Left side (Web only) — Beautiful gradient background
            if (isWeb)
              Expanded(
    flex: 5,
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF6C5CE7)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo
            Image.asset(
              'assets/images/vector.png',
              width: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_rounded,
                size: 140,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // App name below logo
            const Text(
              'myMicroBiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                // letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 8,
                    color: Colors.black26,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
            Text(
              'Manage Your Business Like a Pro',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  ),

            // Right side — Onboarding content
            Expanded(
              flex: isWeb ? 5 : 1,
              child: Column(
                children: [
                  // Skip button (top right)
                  if (!isWeb)
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(onPressed: () async {
                          final prefs = await ref.read(sharedPreferencesProvider.future);
                          await prefs.setBool('onboarding_completed', true);
                          context.go('/login');
                        },
                        child: const Text('Skip', style: TextStyle(color: Colors.grey)),
                      ),
                    ),

                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWeb ? 80 : 32,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image
                              Expanded(
                                flex: isWeb ? 4 : 3,
                                child: Image.asset(
                                  page['image']!,
                                  fit: BoxFit.contain,
                                  width: isWeb ? 500 : screenWidth * 0.8,
                                ),
                              ),
                              const SizedBox(height: 48),

                              // Title
                              Text(
                                page['title']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isWeb ? 42 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 60),

                              // Dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _pages.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    width: i == _currentIndex ? 28 : 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: i == _currentIndex ? AppColors.primary : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60),

                              // Button
                              SizedBox(
                                width: isWeb ? 400 : double.infinity,
                                height: 60,
                                child: ElevatedButton(onPressed: () async {
                                    if (_currentIndex < _pages.length - 1) {
                                      _controller.nextPage(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      final prefs = await ref.read(sharedPreferencesProvider.future);
                                      await prefs.setBool('onboarding_completed', true);
                                      context.go('/login');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 10,
                                    shadowColor: AppColors.primary.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              if (isWeb) const SizedBox(height: 40),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}