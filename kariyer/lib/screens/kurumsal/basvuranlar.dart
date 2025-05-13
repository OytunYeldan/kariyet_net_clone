import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import 'ilan_basvuranlari.dart';

class BasvuranlarPage extends StatefulWidget {
  final UserModel user;
  const BasvuranlarPage({super.key, required this.user});

  @override
  State<BasvuranlarPage> createState() => _BasvuranlarPageState();
}

class _BasvuranlarPageState extends State<BasvuranlarPage> {
  List<JobModel> jobs = [];

  Future<void> fetchJobs() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'jobs',
      where: 'companyId = ?',
      whereArgs: [widget.user.id.toString()],
    );

    setState(() {
      jobs = result.map((e) => JobModel.fromMap(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlanlar")),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (_, index) {
          final job = jobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.skills),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IlanBasvuranlariPage(job: job),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
