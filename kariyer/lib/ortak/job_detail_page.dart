import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../db/database_helper.dart';

class JobDetailPage extends StatelessWidget {
  final JobModel job;
  final UserModel user;

  const JobDetailPage({super.key, required this.job, required this.user});

  Future<void> _applyToJob(BuildContext context) async {
    final db = await DatabaseHelper().database;

    await db.insert('applications', {
      'userId': user.id,
      'jobId': job.id,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Başvuru yapıldı'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pozisyon: ${job.title}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Açıklama:\n${job.description}"),
            const SizedBox(height: 16),
            Text("Yetenekler:\n${job.skills}"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _applyToJob(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text("Başvur", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
