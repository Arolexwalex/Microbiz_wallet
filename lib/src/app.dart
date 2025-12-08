import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'package:new_new_microbiz_wallet/src/features/financing/loan_lender_selection_screen.dart';
import 'theme/theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/pin_screen.dart';
import 'features/auth/new_password_screen.dart';
import 'features/common/success_screen.dart';
import 'features/security/biometric_screen.dart';
import 'features/score/business_health_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/budget/budget_screen.dart';
import 'features/financing/bank_connect_screen.dart';
import 'features/financing/support_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/financing/article_detail_screen.dart';
import 'features/financing/financial_literacy_screen.dart';
import 'features/loan/loan_application_screen.dart';
import 'features/financing/credit_score_screen.dart';
import 'features/financing/financing_screen.dart';
import 'features/reconcile/records/add_expenses_screen.dart';
import 'features/reconcile/records/add_sales_screen.dart';
import 'features/reconcile/records/ledger_screen.dart';
import 'features/reconcile/records/record_detail_screen.dart';
import 'features/reconcile/view.dart';
import 'features/dashboard/dashboard_screen.dart' as dashboard;
import 'features/onboarding/onboarding_screen.dart' as onboarding;
import 'features/invoice/invoice_list_screen.dart';
import 'features/invoice/invoice_create_screen.dart';
import 'features/invoice/invoice_detail_screen.dart';
import 'features/invoice/debt_tracker_screen.dart';
import 'features/loan/loan_status_screen.dart';
import 'state/auth_providers.dart';

class MicroBizApp extends ConsumerWidget {
  const MicroBizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final onboardingCompletedAsync = ref.watch(onboardingCompletedProvider);

    final router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(ref.read(authStateProvider.notifier).stream),
      redirect: (context, state) {
        final isAuth = authState.isAuthenticated;
        final isPublic = ['/splash', '/onboarding', '/login', '/signup', '/forgot', '/pin', '/new-password', '/success'].contains(state.matchedLocation);

        if (onboardingCompletedAsync.isLoading) return null;
        final onboardingDone = onboardingCompletedAsync.value ?? false;

        if (!isAuth) {
          if (!onboardingDone && !state.matchedLocation.startsWith('/onboarding') && !state.matchedLocation.startsWith('/splash')) return '/onboarding';
          if (onboardingDone && !isPublic) return '/login';
        } else {
          if (!onboardingDone && !state.matchedLocation.startsWith('/onboarding')) return '/onboarding';
          if (onboardingDone && isPublic) return '/home';
        }
        return null;
      },
      routes: [
        // Public routes — no nav bar
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/onboarding', builder: (_, __) => const onboarding.OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(path: '/pin', builder: (_, __) => const PinScreen()),
        GoRoute(path: '/new-password', builder: (_, __) => const NewPasswordScreen()),
        GoRoute(path: '/success', builder: (ctx, state) => SuccessScreen(message: state.uri.queryParameters['message'] ?? 'Success')),

        // MAIN SHELL — ALL 5 CORE SCREENS WITH NAVIGATION BAR
        ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const dashboard.DashboardScreen()),
            GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
            GoRoute(path: '/financing', builder: (_, __) => const FinancingScreen()),
            GoRoute(path: '/financial-literacy', builder: (_, __) => const FinancialLiteracyScreen()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          ],
        ),

        // Full-screen routes — NO NAV BAR
        GoRoute(path: '/biometric', builder: (_, __) => const BiometricScreen()),
        GoRoute(path: '/score', builder: (_, __) => const BusinessHealthScreen()),
        GoRoute(path: '/add-sales', builder: (_, __) => const AddSalesScreen()),
        GoRoute(path: '/add-expenses', builder: (_, __) => const AddExpensesScreen()),
        GoRoute(path: '/ledger', builder: (_, __) => const LedgerScreen()),
        GoRoute(path: '/recon', builder: (_, __) => const AutoReconScreen()),
        GoRoute(path: '/bank-connect', builder: (_, __) => const BankConnectScreen()),
        GoRoute(path: '/support', builder: (_, __) => const GovernmentSupportScreen()),
        GoRoute(path: '/business-health', builder: (_, __) => const BusinessHealthScreen()),
        GoRoute(path: '/financial-literacy-detail', builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ArticleDetailScreen(title: extra['title']!, content: extra['content']!);
        }),
        // This now points to the new selection screen
        GoRoute(path: '/apply-for-loan', builder: (_, __) => const LoanLenderSelectionScreen()),
        // This is the new route for the actual application form
        GoRoute(path: '/apply-for-loan/:lender', builder: (context, state) => LoanApplicationScreen(lender: state.pathParameters['lender']!)),
        GoRoute(path: '/credit-score', builder: (_, __) => const CreditScoreScreen()),
        GoRoute(path: '/record-detail', builder: (context, state) => RecordDetailScreen(record: state.extra as LedgerRecord)),
        GoRoute(path: '/invoices', builder: (_, __) => const InvoiceListScreen()),
        GoRoute(path: '/invoice/create', builder: (_, __) => const InvoiceCreateScreen()),
        GoRoute(path: '/invoice/:invoiceId', builder: (context, state) => InvoiceDetailScreen(invoiceId: state.pathParameters['invoiceId']!)),
        GoRoute(path: '/debts', builder: (_, __) => const DebtTrackerScreen()),
        GoRoute(path: '/loan-status', builder: (_, __) => const LoanStatusScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'MicroBiz Wallet',
      theme: buildLightTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

// MAIN LAYOUT — PERSISTENT NAVIGATION
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
    final currentPath = GoRouterState.of(context).uri.path;
    int selectedIndex = _tabs.indexWhere((tab) => currentPath.startsWith(tab));
    if (selectedIndex == -1) selectedIndex = 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Web: Side Navigation Rail
          if (isWeb)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => context.go(_tabs[i]),
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primary.withOpacity(0.2),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_rounded), selectedIcon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.bar_chart_rounded), selectedIcon: Icon(Icons.bar_chart), label: Text('Reports')),
                NavigationRailDestination(icon: Icon(Icons.account_balance_rounded), selectedIcon: Icon(Icons.account_balance), label: Text('Financing')),
                NavigationRailDestination(icon: Icon(Icons.school_rounded), selectedIcon: Icon(Icons.school), label: Text('Literacy')),
                NavigationRailDestination(icon: Icon(Icons.person_rounded), selectedIcon: Icon(Icons.person), label: Text('Profile')),
              ],
            ),

          // Main Content
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
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              backgroundColor: AppColors.surface,
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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}