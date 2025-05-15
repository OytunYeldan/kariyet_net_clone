import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import 'user_detail_page.dart';

class IlanBasvuranlariPage extends StatefulWidget {
  final JobModel job;
  const IlanBasvuranlariPage({super.key, required this.job});

  @override
  State<IlanBasvuranlariPage> createState() => _IlanBasvuranlariPageState();
}

class _IlanBasvuranlariPageState extends State<IlanBasvuranlariPage> {
  List<UserModel> applicants = [];
  bool _isLoading = true;

  Future<void> fetchApplicants() async {
    final db = await DatabaseHelper().database;
    try {
      final result = await db.rawQuery('''
        SELECT u.* FROM applications a
        INNER JOIN users u ON a.userId = u.id
        WHERE a.jobId = ?
      ''', [widget.job.id]);

      setState(() {
        applicants = result.map((e) => UserModel.fromMap(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Başvuranları yüklerken bir hata oluştu: ${e.toString()}'),
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
    fetchApplicants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Başvuranlar - ${widget.job.title}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicants.isEmpty
          ? const Center(
        child: Text(
          "Henüz başvuran yok.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (_, index) {
          final user = applicants[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                user.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo),
              ),
              subtitle: Text(
                user.skills,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailPage(user: user, job: widget.job),
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
