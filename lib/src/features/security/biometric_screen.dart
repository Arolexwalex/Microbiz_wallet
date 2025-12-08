import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/biometric_provider.dart';
import '../../widgets/curved_header.dart';

class BiometricScreen extends ConsumerWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          CurvedHeader(
            height: 140,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                const Icon(Icons.fingerprint, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Biometric Security',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.fingerprint, size: 120),
                      const SizedBox(height: 16),
                      const Text('Use Fingerprint To Access', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (kIsWeb)
                        const Card(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Biometric security is only available on the mobile app.')))
                      else
                        SwitchListTile(
                          title: const Text('Enable biometric unlock'),
                          value: ref.watch(biometricEnabledProvider),
                          onChanged: (v) => ref.read(biometricEnabledProvider.notifier).toggle(v),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
