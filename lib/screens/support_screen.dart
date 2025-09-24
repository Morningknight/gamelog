import 'package:flutter/material.dart';
import 'package:gamelog/models/donation_log.dart'; // <-- CORRECTED IMPORT
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late final Future<List<DonationLogEntry>> _donationLogFuture;
  final DonationLogService _logService = DonationLogService();

  @override
  void initState() {
    super.initState();
    _donationLogFuture = _logService.loadLog();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    const String buyMeACoffeeUrl = 'https://www.buymeacoffee.com/your_username';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Charity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enjoying GameLog?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'If you find this app useful, please consider supporting its development. Every contribution helps and is greatly appreciated!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.coffee),
                label: const Text('Support on Buy Me a Coffee'),
                onPressed: () => _launchUrl(buyMeACoffeeUrl),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Donation Log',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'As a commitment to giving back, 10% of all monthly support is donated to charity. Thank you for making a difference!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<DonationLogEntry>>(
              future: _donationLogFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading donation log: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No donation entries yet. Be the first to contribute!'));
                }

                final logEntries = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logEntries.length,
                  itemBuilder: (context, index) {
                    final entry = logEntries[index];
                    return _buildLogEntryCard(entry);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntryCard(DonationLogEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.date,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            _buildStatRow('Total Support:', entry.totalDonations),
            const SizedBox(height: 8),
            _buildStatRow('10% Donated:', entry.charityAmount),
            const SizedBox(height: 8),
            _buildStatRow('To:', entry.charityName),
            if (entry.receiptUrl != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.receipt_long, size: 16),
                label: const Text('View Receipt'),
                onPressed: () => _launchUrl(entry.receiptUrl!),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}