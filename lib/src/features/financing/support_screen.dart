import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/curved_header.dart';

class GovernmentSupportScreen extends StatelessWidget {
  const GovernmentSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grants = [
      {
        'title': "Presidential Conditional Grant Scheme 2025",
        'amount': "₦50,000 – ₦250,000",
        'description': "Free grant for nano/micro businesses. 1 million beneficiaries.",
        'link': "https://grant.fedgrantandloan.gov.ng"
      },
      {
        'title': "SMEDAN Conditional Grant Scheme",
        'amount': "₦50,000",
        'description': "A grant to support micro-enterprises across Nigeria.",
        'link': "https://smedan.gov.ng/our-programs/cgs/"
      },
      {
        'title': "BOI SME Loan (Single Digit)",
        'amount': "Up to ₦1 billion",
        'description': "Low-interest loans for small and medium enterprises.",
        'link': "https://www.boi.ng"
      },
      {
        'title': "Tony Elumelu Entrepreneurship Programme 2026",
        'amount': "\$5,000 grant + training",
        'description': "Flagship entrepreneurship program for African entrepreneurs.",
        'link': "https://www.tefconnect.com"
      },
      {
        'title': "GET Compass Grant 2025 Cohort 4",
        'amount': "Up to ₦2 million",
        'description': "Grant and mentorship for young Nigerian entrepreneurs.",
        'link': "https://getcompassgrant.com"
      },
    ];

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
                const Icon(Icons.policy_outlined, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Grants & Support',
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: grants.length,
                  itemBuilder: (context, index) {
                    final grant = grants[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(grant['title']!, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(grant['description']!),
                            const SizedBox(height: 8),
                            Chip(label: Text(grant['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  final url = Uri.parse(grant['link']!);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: const Text('Learn More & Apply'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
                          