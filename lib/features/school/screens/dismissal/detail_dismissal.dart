import 'package:flutter/material.dart';

class StudentDismissalDetailScreen extends StatelessWidget {
  final String studentId;
  final List<Map<String, dynamic>> dismissalRequests;
  const StudentDismissalDetailScreen({
    super.key,
     required this.studentId,
     required this.dismissalRequests
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dismissal Detail for $studentId'),
      ),

      body: ListView.builder(
        itemCount: dismissalRequests.length,
        itemBuilder: ((context, index) {
          final request = dismissalRequests[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Status: ${request['status']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Authorized Person: ${request['authorizedPerson'] ?? 'N/A'}'),
                  Text('Phone: ${request['phone'] ?? 'N/A'}'),
                ],
              ),
            ),
          );
        })
      ),
    );
  }
}