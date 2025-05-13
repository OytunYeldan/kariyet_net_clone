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

  Future<void> fetchApplicants() async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery('''
      SELECT u.* FROM applications a
      INNER JOIN users u ON a.userId = u.id
      WHERE a.jobId = ?
    ''', [widget.job.id]);

    setState(() {
      applicants = result.map((e) => UserModel.fromMap(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Başvuranlar - ${widget.job.title}")),
      body: applicants.isEmpty
          ? const Center(child: Text("Henüz başvuran yok."))
          : ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (_, index) {
          final user = applicants[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.skills),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserDetailPage(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
