import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'MoneyCtrl',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'v1.0.1',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            const Text(
              'ATTRIBUTIONS & LICENSE',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Licensed Under Apache 2.0 License',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              'VISIT',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _launchURL('https://github.com/subhipandey/MoneyCtrl'),
              child: const Text(
                'Github',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}