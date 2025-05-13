import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/job.dart';
import '../../models/user.dart';

class EslesenIlanlarPage extends StatefulWidget {
  final UserModel user;
  const EslesenIlanlarPage({super.key, required this.user});

  @override
  State<EslesenIlanlarPage> createState() => _EslesenIlanlarPageState();
}

class _EslesenIlanlarPageState extends State<EslesenIlanlarPage> {
  List<JobModel> eslesen = [];

  @override
  void initState() {
    super.initState();
    fetchEslesen();
  }

  Future<void> fetchEslesen() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('jobs');
    final allJobs = result.map((e) => JobModel.fromMap(e)).toList();

    final userSkills = widget.user.skills!.toLowerCase().split(',').map((e) => e.trim()).toList();

    final matchedJobs = allJobs.where((job) {
      final jobSkills = job.skills.toLowerCase();
      return userSkills.any((skill) => jobSkills.contains(skill));
    }).toList();

    setState(() {
      eslesen = matchedJobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eşleşen İlanlar")),
      body: ListView.builder(
        itemCount: eslesen.length,
        itemBuilder: (_, index) {
          final job = eslesen[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.skills),
          );
        },
      ),
    );
  }
}
