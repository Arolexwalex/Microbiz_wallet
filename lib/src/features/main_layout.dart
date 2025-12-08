// lib/src/features/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  static const _tabs = [
    '/home',
    '/reports',
    '/financing',
    '/financial-literacy',
    '/profile',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width >= 900;
    final currentLocation = GoRouterState.of(context).uri.path;

    int selectedIndex = _tabs.indexWhere((tab) => currentLocation.startsWith(tab));
    selectedIndex = selectedIndex == -1 ? 0 : selectedIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Web: Side Navigation Rail
          if (isWeb)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => context.go(_tabs[i]),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_rounded), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.bar_chart_rounded), label: Text('Reports')),
                NavigationRailDestination(icon: Icon(Icons.account_balance_rounded), label: Text('Financing')),
                NavigationRailDestination(icon: Icon(Icons.school_rounded), label: Text('Literacy')),
                NavigationRailDestination(icon: Icon(Icons.person_rounded), label: Text('Profile')),
              ],
            ),

          // Main content
          Expanded(child: child),
        ],
      ),

      // Mobile: Bottom Navigation Bar
      bottomNavigationBar: isWeb
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (i) => context.go(_tabs[i]),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: 'Financing'),
                BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Literacy'),
                BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
            ),
    );
  }
}