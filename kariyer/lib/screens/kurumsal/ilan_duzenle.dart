import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/job.dart';

class IlanDuzenlePage extends StatefulWidget {
  final JobModel job;
  const IlanDuzenlePage({super.key, required this.job});

  @override
  State<IlanDuzenlePage> createState() => _IlanDuzenlePageState();
}

class _IlanDuzenlePageState extends State<IlanDuzenlePage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController skillsController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.job.title);
    descController = TextEditingController(text: widget.job.description);
    skillsController = TextEditingController(text: widget.job.skills);
  }

  Future<void> updateJob() async {
    final db = await DatabaseHelper().database;

    final updatedJob = JobModel(
      id: widget.job.id,
      title: titleController.text,
      description: descController.text,
      skills: skillsController.text,
      companyId: widget.job.companyId,
    );

    await db.update(
      'jobs',
      updatedJob.toMap(),
      where: 'id = ?',
      whereArgs: [widget.job.id],
    );

    Navigator.pop(context); // geri dön
  }

  Future<void> deleteJob() async {
    final db = await DatabaseHelper().database;

    // İlanı sil
    await db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [widget.job.id],
    );

    // Başvuruları da sil (isteğe bağlı)
    await db.delete(
      'applications',
      where: 'jobId = ?',
      whereArgs: [widget.job.id],
    );

    Navigator.pop(context); // geri dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlanı Düzenle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("İlanı Sil"),
                  content: const Text("Bu ilanı silmek istediğinize emin misiniz?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // dialogu kapat
                        await deleteJob();
                      },
                      child: const Text("Sil", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Başlık")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Açıklama")),
            TextField(controller: skillsController, decoration: const InputDecoration(labelText: "Yetenekler")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateJob, child: const Text("Güncelle")),
          ],
        ),
      ),
    );
  }
}
