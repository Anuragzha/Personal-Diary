import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current year dynamically
    final currentYear = DateTime.now().year.toString();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Column(
        children: [
          const Divider(color: Colors.white30, height: 1),
          const SizedBox(height: 8),
          Text(
            '© $currentYear Personal Diary | Anurag all rights reserved.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
