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
  TextEditingController _searchController = TextEditingController();

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
      _filteredJobs = List.from(_allJobs);  // Başlangıçta tüm ilanlar gösterilsin
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
      appBar: AppBar(title: const Text("İlanlar")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'İş Ara',
                hintText: 'Pozisyon, yetenek veya açıklama',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredJobs.isEmpty
                ? const Center(child: Text("İlan bulunamadı."))
                : ListView.builder(
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(job.title),
                    subtitle: Text(job.skills),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(job: job, user: widget.user),
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
