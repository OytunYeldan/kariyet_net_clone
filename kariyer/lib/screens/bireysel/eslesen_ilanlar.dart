import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import 'package:kariyer/ortak/job_detail_page.dart';
class EslesenIlanlarPage extends StatefulWidget {
  final UserModel user;
  const EslesenIlanlarPage({super.key, required this.user});

  @override
  State<EslesenIlanlarPage> createState() => _EslesenIlanlarPageState();
}

class _EslesenIlanlarPageState extends State<EslesenIlanlarPage> {
  List<JobModel> _eslesen = [];
  bool _isLoading = true; // Added for loading state

  @override
  void initState() {
    super.initState();
    fetchEslesen();
  }

  Future<void> fetchEslesen() async {
    final db = await DatabaseHelper().database;
    try {
      final result = await db.query('jobs');
      final allJobs = result.map((e) => JobModel.fromMap(e)).toList();

      final userSkills = widget.user.skills!.toLowerCase().split(',').map((e) => e.trim()).toList();

      final matchedJobs = allJobs.where((job) {
        final jobSkills = job.skills.toLowerCase();
        return userSkills.any((skill) => jobSkills.contains(skill));
      }).toList();

      setState(() {
        _eslesen = matchedJobs;
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      if (mounted) { //check if the widget is mounted before using context
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eşleşen ilanları yüklerken bir hata oluştu: ${e.toString()}'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eşleşen İlanlar", style: TextStyle(color: Colors.white)), // Consistent AppBar style
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _eslesen.isEmpty
          ? const Center(
        child: Text(
          "Eşleşen ilan bulunamadı.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ) //Message when there are no matching jobs
          : ListView.builder(
        itemCount: _eslesen.length,
        itemBuilder: (context, index) {
          final job = _eslesen[index];
          return Card(
            elevation: 3, // Added elevation
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Consistent margins
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailPage(job: job, user: widget.user), // Navigate to JobDetailPage
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
