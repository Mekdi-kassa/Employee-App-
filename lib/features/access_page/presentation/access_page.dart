import 'package:employee_app/core/color/theme.dart';
import 'package:employee_app/features/login/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeWebsite {
  final String title;
  final String description;
  final String url;
  final List<String> highlights;
  const EmployeeWebsite({required this.title, required this.description, required this.url, required this.highlights});
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<EmployeeWebsite> websites = const [
    EmployeeWebsite(
      title: 'Employee Self-Service (ESS)',
      description: 'Access pay slips, leave requests, and HR profiles.',
      url: 'https://github.com/',
      highlights: ['Profile summary', 'Latest payslip', 'Leave balance', 'Pending requests'],
    ),
    EmployeeWebsite(
      title: 'Internal Crew Portal',
      description: 'Check operational flight information parameters and active rosters.',
      url: 'https://github.com/',
      highlights: ['Duty roster', 'Route briefing', 'Flight updates', 'Crew notices'],
    ),
    EmployeeWebsite(
      title: 'HR Quick Actions',
      description: 'Submit forms and review common employee actions.',
      url: 'https://github.com/',
      highlights: ['Leave request', 'Document upload', 'Support ticket', 'Contacts'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Hub'),
        actions: [
          IconButton(
            icon: Icon(auth.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => auth.toggleTheme(!auth.isDarkMode),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => auth.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: websites.length,
        itemBuilder: (context, index) {
          final site = websites[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.brandGreen.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.language_rounded, color: AppTheme.brandGreen),
              ),
              title: Text(site.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(site.description, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewPage(title: site.title, description: site.description, url: site.url, highlights: site.highlights)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  static const MethodChannel _channel = MethodChannel('employee_app/browser');

  final String title;
  final String description;
  final String url;
  final List<String> highlights;
  const WebViewPage({super.key, required this.title, required this.description, required this.url, required this.highlights});

  Future<void> _openWebsite(BuildContext context) async {
    try {
      await _channel.invokeMethod<void>('openUrl', {'url': url});
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the website.')),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: AppTheme.brandGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Demo GitHub link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SelectableText(url, style: const TextStyle(fontSize: 15, color: AppTheme.brandGreen)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _openWebsite(context),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Open website'),
            ),
            const SizedBox(height: 20),
            const Text('Demo sections', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...highlights.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline_rounded, color: AppTheme.brandGreen),
                  title: Text(item),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}