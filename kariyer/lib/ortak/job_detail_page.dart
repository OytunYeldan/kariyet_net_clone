import 'package:flutter/material.dart';
import 'package:kariyer/screens/bireysel/job_map_page.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../db/database_helper.dart';

class JobDetailPage extends StatefulWidget {
  final JobModel job;
  final UserModel user;

  const JobDetailPage({super.key, required this.job, required this.user});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool _hasApplied = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
  }

  Future<void> _checkIfApplied() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'applications',
      where: 'userId = ? AND jobId = ?',
      whereArgs: [widget.user.id, widget.job.id],
    );

    setState(() {
      _hasApplied = result.isNotEmpty;
      _isLoading = false;
    });
  }

  Future<void> _applyToJob(BuildContext context) async {
    if (_hasApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu ilana zaten başvurdunuz.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    try {
      await db.insert('applications', {
        'userId': widget.user.id,
        'jobId': widget.job.id,
      });

      setState(() {
        _hasApplied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Başvurunuz başarıyla alınmıştır.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Başvuru sırasında bir hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pozisyon Kartı
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.job.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Pozisyon",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            // Açıklama
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Açıklama",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(widget.job.description,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            // Yetenekler
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Yetenekler",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(widget.job.skills, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            // Konum ve Harita Butonu
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Text("İş Konumu",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.job.location,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.map_outlined),
                        label: const Text("Haritada Aç"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JobMapPage(location: widget.job.location),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Başvuru Butonu
            Center(
              child: ElevatedButton.icon(
                onPressed: _hasApplied ? null : () => _applyToJob(context),
                icon: const Icon(Icons.send),
                label: Text(
                  _hasApplied ? "Zaten Başvurdunuz" : "Başvur",
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 16),
                  backgroundColor: _hasApplied
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
