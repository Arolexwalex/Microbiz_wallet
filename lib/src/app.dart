// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/features/reconcile/records/add_expenses_screen.dart';
import 'package:new_new_microbiz_wallet/src/features/reconcile/records/add_sales_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
import 'features/financing/bank_connect_screen.dart';
import 'features/financing/support_screen.dart';
import 'features/loan/select_lender_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/financing/financial_literacy_screen.dart';
import 'features/loan/loan_application_screen.dart';
import 'features/financing/credit_score_screen.dart';
import 'features/financing/financing_screen.dart';
import 'features/reconcile/records/ledger_screen.dart';
import 'features/reconcile/view.dart';
import 'features/dashboard/dashboard_screen.dart' as dashboard;
import 'features/onboarding/onboarding_screen.dart' as onboarding;
import 'features/invoice/invoice_list_screen.dart';
import 'features/invoice/invoice_create_screen.dart' hide Text;
import 'features/invoice/invoice_detail_screen.dart';
import 'features/invoice/debt_tracker_screen.dart';
import 'features/loan/loan_status_screen.dart';
import 'features/main_layout.dart';

class MicroBizApp extends ConsumerWidget {
  const MicroBizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = Supabase.instance.client;

    final router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = supabase.auth.currentUser != null;
        final isLoggingIn = state.matchedLocation == '/login' || 
                            state.matchedLocation == '/signup' || 
                            state.matchedLocation == '/forgot';

        if (isLoggedIn && isLoggingIn) return '/home';
        if (!isLoggedIn && !isLoggingIn) return '/login';
        return null;
      },
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(path: '/pin', builder: (_, __) => const PinScreen()),
        GoRoute(path: '/new-password', builder: (_, __) => const NewPasswordScreen()),
        GoRoute(path: '/success', builder: (ctx, state) => SuccessScreen(message: state.uri.queryParameters['message'] ?? 'Success')),

        // The ShellRoute now acts as the main wrapper for all authenticated routes.
        ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            // Core navigation tabs
            GoRoute(path: '/home', builder: (_, __) => const dashboard.DashboardScreen()),
            GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
            GoRoute(path: '/financing', builder: (_, __) => const FinancingScreen()),
            GoRoute(path: '/financial-literacy', builder: (_, __) => const FinancialLiteracyScreen()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),

            // Other full-screen routes that are part of the main app experience
            GoRoute(path: '/biometric', builder: (_, __) => const BiometricScreen()),
            GoRoute(path: '/score', builder: (_, __) => const BusinessHealthScreen()),
            GoRoute(path: '/business-health', builder: (_, __) => const BusinessHealthScreen()),
            GoRoute(path: '/ledger', builder: (_, __) => const LedgerScreen()),
            GoRoute(path: '/recon', builder: (_, __) => const AutoReconScreen()),
            GoRoute(path: '/bank-connect', builder: (_, __) => const BankConnectScreen()),
            GoRoute(path: '/support', builder: (_, __) => const GovernmentSupportScreen()),
            GoRoute(path: '/credit-score', builder: (_, __) => const CreditScoreScreen()),
            GoRoute(path: '/invoices', builder: (_, __) => const InvoiceListScreen()),
            GoRoute(path: '/invoice/create', builder: (_, __) => const InvoiceCreateScreen()),
            GoRoute(
              path: '/invoice/:id',
              builder: (context, state) =>
                  InvoiceDetailScreen(invoiceId: int.parse(state.pathParameters['id']!)),
            ),
            GoRoute(path: '/debts', builder: (_, __) => const DebtTrackerScreen()),
            GoRoute(path: '/loan-status', builder: (_, __) => const LoanStatusScreen()),
            GoRoute(path: '/select-lender', builder: (_, __) => const SelectLenderScreen()),
            GoRoute(path: '/apply-for-loan/:lender', builder: (context, state) => LoanApplicationScreen(lender: state.pathParameters['lender']!)),

            // Add the missing routes for adding sales and expenses
            GoRoute(path: '/add-sales', builder: (_, __) => const AddSalesScreen()),
            GoRoute(path: '/add-expenses', builder: (_, __) => const AddExpensesScreen()),

            // Add missing routes from Profile screen
            // TODO: Create these screen files
            GoRoute(path: '/settings', builder: (_, __) => const Scaffold(body: Center(child: Text('Settings Screen')))),
            GoRoute(path: '/change-password', builder: (_, __) => const Scaffold(body: Center(child: Text('Change Password Screen')))),
            GoRoute(path: '/delete-account', builder: (_, __) => const Scaffold(body: Center(child: Text('Delete Account Screen')))),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'myMicroBiz',
      theme: buildLightTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}