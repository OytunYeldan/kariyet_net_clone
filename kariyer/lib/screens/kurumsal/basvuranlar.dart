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
  bool _isLoading = true;

  Future<void> fetchJobs() async {
    final db = await DatabaseHelper().database;
    try {
      final result = await db.query(
        'jobs',
        where: 'companyId = ?',
        whereArgs: [widget.user.id.toString()],
      );

      setState(() {
        jobs = result.map((e) => JobModel.fromMap(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İlanları yüklerken bir hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlanlar", style: TextStyle(color: Colors.white)), // Consistent AppBar title style
        backgroundColor: Theme.of(context).primaryColor, // Consistent AppBar color
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(
        child: Text(
          "Henüz ilanınız yok.",
          style: TextStyle(fontSize: 16, color: Colors.grey), // Consistent empty message
        ),
      )
          : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (_, index) {
          final job = jobs[index];
          return Card(
            elevation: 3, // Added elevation for shadow
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Consistent margins
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: ListTile(
              title: Text(
                job.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo), // Title style
              ),
              subtitle: Text(
                job.skills,
                style: TextStyle(color: Colors.grey.shade600), // Subtitle style
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IlanBasvuranlariPage(job: job),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

