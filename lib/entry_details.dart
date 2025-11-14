// entry_details.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_entry.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryDetailsPage extends StatelessWidget {
  final String entryId;

  const EntryDetailsPage({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user (shouldn't normally happen when navigating here)
      return Scaffold(
        appBar: AppBar(title: const Text('Entry')),
        body: const Center(child: Text('User not logged in.')),
      );
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('entries')
        .doc(entryId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Fetch current data to prefill the edit screen
              final snapshot = await docRef.get();
              if (!snapshot.exists) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entry not found.')),
                  );
                }
                return;
              }
              final data = snapshot.data() as Map<String, dynamic>;
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEntryPage(
                      entryId: entryId,
                      oldTitle: data['title'] ?? '',
                      oldContent: data['content'] ?? '',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Entry not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
          final edited = (data['editedTimestamp'] as Timestamp?)?.toDate();

          final formattedTime = timestamp != null
              ? DateFormat('EEE, dd MMM yyyy – hh:mm a').format(timestamp)
              : 'No Date';

          final editedTimeText = (edited != null)
              ? ' • Edited ${DateFormat('dd MMM yyyy • hh:mm a').format(edited)}'
              : '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? 'Untitled',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$formattedTime$editedTimeText',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['content'] ?? '',
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
