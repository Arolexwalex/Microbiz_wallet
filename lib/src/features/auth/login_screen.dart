import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
import '../../widgets/curved_header.dart';
import '../../theme/theme.dart';
import '../../state/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); // Changed from _emailController to _usernameController
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Attempt biometric login on mobile if available and user is already logged in
    if (!kIsWeb) {
      _checkBiometricLogin();
    }
  }

  Future<void> _checkBiometricLogin() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    // We assume isLoggedIn checks for a valid stored token
    if (await authNotifier.isLoggedIn() && await _authenticateWithBiometrics()) {
      if (mounted) context.go('/home');
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(signInTitle: 'Authenticate'),
        ],
      );
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CurvedHeader(
                          height: 140,
                          child: Icon(Icons.lock_rounded, color: Colors.white, size: 48, semanticLabel: 'Login Icon'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome to MicroBiz Wallet',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController, // Using _usernameController
                          decoration: InputDecoration(
                            labelText: 'Username', // Changed label to Username
                            hintText: 'Enter your username',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.normal),
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.text, // Changed keyboard type
                          autofillHints: const [AutofillHints.username], // Changed autofill hint
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.normal),
                            errorStyle: const TextStyle(color: Colors.red),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password cannot be empty';
                            }
                            // if (value.length < 8 || !value.contains(RegExp(r'[0-9]')) || !value.contains(RegExp(r'[!@#$%^&*]'))) {
                            //   return 'Password must be at least 8 characters with a number and special character';
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Removed 'Remember Me' checkbox for MVP to simplify token management
                            // for now, as it's typically handled by the persistence of the JWT.
                            TextButton(
                              onPressed: () => context.go('/forgot'),
                              child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    setState(() => _isLoading = true);
                                    try {
                                      await ref.read(authStateProvider.notifier).login(
                                        username: _usernameController.text, // Pass username
                                        password: _passwordController.text,
                                      );
                                      if (context.mounted) {
                                        context.go('/home');
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                      }
                                    }
                                    setState(() => _isLoading = false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Log In'),
                              ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    await ref.read(authStateProvider.notifier).demoLogin();
                                    if (context.mounted) {
                                      context.go('/home');
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    }
                                  }
                                  setState(() => _isLoading = false);
                                },
                          child: const Text('Continue as Demo User'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => context.go('/signup'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Sign Up', style: TextStyle(color: AppColors.primary)),
                        ),
                        const SizedBox(height: 16),
                    if (!kIsWeb) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.fingerprint, color: AppColors.primary),
                        onPressed: _checkBiometricLogin,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                        ),
                        label: const Text('Login with Biometrics', style: TextStyle(color: AppColors.primary)),
                      ),
                      const SizedBox(height: 16),
                    ],
                        const Text(
                          'By logging in, you agree to our Terms of Service and Privacy Policy.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}