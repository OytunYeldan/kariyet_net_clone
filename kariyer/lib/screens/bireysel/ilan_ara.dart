import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../db/database_helper.dart';
import 'package:kariyer/ortak/job_detail_page.dart';

class IlanlarPage extends StatefulWidget {
  final UserModel user;
  const IlanlarPage({super.key, required this.user});

  @override
  State<IlanlarPage> createState() => _IlanlarPageState();
}

class _IlanlarPageState extends State<IlanlarPage> {
  List<JobModel> _allJobs = [];
  List<JobModel> _filteredJobs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _searchController.addListener(_filterJobs);
  }

  Future<void> _loadJobs() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'jobs',
      whereArgs: [1], // Aktif ilanlar
    );

    setState(() {
      _allJobs = result.map((e) => JobModel.fromMap(e)).toList();
      _filteredJobs = List.from(_allJobs);
    });
  }

  void _filterJobs() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        return job.title.toLowerCase().contains(keyword) ||
            job.description.toLowerCase().contains(keyword) ||
            job.skills.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlanlar", style: TextStyle(color: Colors.white)), // AppBar text color
        backgroundColor: Theme.of(context).primaryColor, // AppBar background color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'İş Ara',
                    hintText: 'Pozisyon, yetenek...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredJobs.isEmpty
                ? const Center(
              child: Text(
                "Aradığınız kriterlere uygun ilan bulunamadı.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      job.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo),
                    ),
                    subtitle: Text(
                      job.skills,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              JobDetailPage(job: job, user: widget.user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

