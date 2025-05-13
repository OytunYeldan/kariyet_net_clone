import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../db/database_helper.dart';
import 'ilan_duzenle.dart';
import 'ilan_ekle.dart';

class IlanlarPage extends StatefulWidget {
  final UserModel user;
  const IlanlarPage({super.key, required this.user});

  @override
  State<IlanlarPage> createState() => _IlanlarPageState();
}

class _IlanlarPageState extends State<IlanlarPage> {
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

  void _navigateAndRefresh(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    fetchJobs(); // sayfa dönüşte ilanları yenile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlanlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _navigateAndRefresh(IlanEklePage(user: widget.user));
            },
          ),
        ],
      ),
      body: jobs.isEmpty
          ? const Center(child: Text("Henüz ilanınız yok."))
          : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (_, index) {
          final job = jobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.skills),
            onTap: () {
              _navigateAndRefresh(IlanDuzenlePage(job: job));
            },
          );
        },
      ),
    );
  }
}
