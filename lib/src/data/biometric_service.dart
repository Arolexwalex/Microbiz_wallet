import 'package:local_auth/local_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static const String _enabledKey = 'biometric_enabled_v1';
  final auth.LocalAuthentication _auth = auth.LocalAuthentication();

  Future<bool> isDeviceSupported() => _auth.isDeviceSupported();
  Future<bool> canCheck() => _auth.canCheckBiometrics;

  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    final didAuth = await _auth.authenticate(
      localizedReason: reason,
      biometricOnly: true,
    );
    return didAuth;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  Future<bool> getEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }
}