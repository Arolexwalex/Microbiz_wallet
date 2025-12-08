import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/biometric_service.dart';

final biometricServiceProvider = Provider((ref) => BiometricService());

final biometricEnabledProvider = StateNotifierProvider<BiometricNotifier, bool>((ref) =>
    BiometricNotifier(service: ref.watch(biometricServiceProvider))..load());

class BiometricNotifier extends StateNotifier<bool> {
  final BiometricService service;
  BiometricNotifier({required this.service}) : super(false);

  Future<void> load() async {
    state = await service.getEnabled();
  }

  Future<void> toggle(bool enabled) async {
    await service.setEnabled(enabled);
    state = enabled;
  }

  Future<bool> authenticate() => service.authenticate(reason: 'Use fingerprint to access MicroBiz Wallet');
}


