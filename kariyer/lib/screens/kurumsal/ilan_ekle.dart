import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/user.dart';
import '../../models/job.dart';

class IlanEklePage extends StatefulWidget {
  final UserModel user;
  const IlanEklePage({super.key, required this.user});

  @override
  State<IlanEklePage> createState() => _IlanEklePageState();
}

class _IlanEklePageState extends State<IlanEklePage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final skillsController = TextEditingController();

  Future<void> saveJob() async {
    final job = JobModel(
      title: titleController.text,
      description: descController.text,
      skills: skillsController.text,
      companyId: widget.user.id.toString(),
    );

    final db = await DatabaseHelper().database;
    await db.insert('jobs', job.toMap());
    Navigator.pop(context); // geri dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni İlan Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Başlık")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Açıklama")),
            TextField(controller: skillsController, decoration: const InputDecoration(labelText: "Yetenekler")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveJob, child: const Text("Kaydet")),
          ],
        ),
      ),
    );
  }
}
