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
  bool _isLoading = true; // Added for loading state

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
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İlanlar yüklenirken bir hata oluştu: ${e.toString()}'),
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
        title: const Text('İlanlarım', style: TextStyle(color: Colors.white)), // Consistent AppBar title style
        backgroundColor: Theme.of(context).primaryColor, // Consistent AppBar color
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : jobs.isEmpty
          ? const Center(
        child: Text(
          "Henüz ilanınız yok.",
          style: TextStyle(fontSize: 16, color: Colors.grey), // Consistent empty message style
        ),
      )
          : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (_, index) {
          final job = jobs[index];
          return Card(
            elevation: 3, // Added elevation for a shadow effect
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Consistent margins
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners for the Card
            ),
            child: ListTile(
              title: Text(
                job.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo), // Consistent title style
              ),
              subtitle: Text(
                job.skills,
                style: TextStyle(color: Colors.grey.shade600), // Consistent subtitle style
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue), // Consistent trailing icon
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: () {
                _navigateAndRefresh(IlanDuzenlePage(job: job));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(        // Added FloatingActionButton
        onPressed: () {
          _navigateAndRefresh(IlanEklePage(user: widget.user));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'İlan Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

