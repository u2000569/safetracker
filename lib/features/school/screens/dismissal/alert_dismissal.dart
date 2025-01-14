import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:safetracker/utils/logging/logger.dart';

class AlertDismissalScreen extends StatelessWidget {
  const AlertDismissalScreen({super.key});

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    final _db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismissal Alert'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collectionGroup('AlertDismissalRequest')
                .where('status', isEqualTo: 'Calling')
                .orderBy('requestTime', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError){
            SLoggerHelper.error('Error: ${snapshot.error}');
            return Center(
              child: Text('An error occurred while loading data: ${snapshot.error}'),
            );
          }

          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text(
                'No Dismissal Alert Request',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final alertDismissal = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alertDismissal.length,
            itemBuilder: (context, index){
              final dismissal = alertDismissal[index];
              // final studentId = dismissal['studentId'] ?? 'Unknown';
              final studentName = dismissal['studentName'] ?? 'Unknown';
              final studentClass = dismissal['studentClass'] ?? 'Unknown';
              final status = dismissal['status'] ?? 'Unknown';
              final parentName = dismissal['parentName'] ?? 'Unknown';
              final requestTime = dismissal['requestTime'] ?? 'Unknown' as Timestamp;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(studentName, style: const TextStyle(fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class: $studentClass'),
                      Text('Parent: $parentName'),
                      Text('Status: $status'),
                      Text('Request Time: ${formatTimestamp(requestTime)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.check),
                    onPressed: (){

                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}