import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/curved_header.dart';

class FinancialLiteracyScreen extends StatefulWidget {
  const FinancialLiteracyScreen({super.key});

  @override
  State<FinancialLiteracyScreen> createState() => _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState extends State<FinancialLiteracyScreen> {
  final _controller = YoutubePlayerController(
    initialVideoId: 'dQw4w9WgXcQ', // Replace with real video ID, e.g., bookkeeping tutorial
    flags: const YoutubePlayerFlags(autoPlay: false),
  );

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
                  onPressed: () => context.pop()
                ),
                const Icon(Icons.school_outlined, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Financial Literacy Hub',
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
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text('Bookkeeping Basics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Understanding Loan Terms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // Add more videos or articles (text cards)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Article: How to apply for government grants in Nigeria.'),
                      ),
                    ),
                  ],
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}