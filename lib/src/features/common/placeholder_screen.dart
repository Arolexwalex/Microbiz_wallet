import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/curved_header.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.construction, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('This feature is coming soon!', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}