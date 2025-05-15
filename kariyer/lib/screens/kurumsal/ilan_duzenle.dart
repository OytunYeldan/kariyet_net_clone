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
  late TextEditingController locationController;
  late TextEditingController salaryController;
  final _formKey = GlobalKey<FormState>(); // Added form key for validation

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.job.title);
    descController = TextEditingController(text: widget.job.description);
    skillsController = TextEditingController(text: widget.job.skills);
    locationController = TextEditingController(text: widget.job.location);
    salaryController = TextEditingController(text: widget.job.salary);
  }

  Future<void> updateJob() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;

      final updatedJob = JobModel(
        id: widget.job.id,
        title: titleController.text,
        description: descController.text,
        skills: skillsController.text,
        companyId: widget.job.companyId,
        location: locationController.text,
        salary: salaryController.text,
      );

      await db.update(
        'jobs',
        updatedJob.toMap(),
        where: 'id = ?',
        whereArgs: [widget.job.id],
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteJob() async {
    final db = await DatabaseHelper().database;

    await db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [widget.job.id],
    );

    await db.delete(
      'applications',
      where: 'jobId = ?',
      whereArgs: [widget.job.id],
    );
    if (mounted) {
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlanı Düzenle", style: TextStyle(color: Colors.white)), // Consistent AppBar title style
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white), // Consistent delete icon color
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
                        Navigator.pop(context);
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Başlık",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Başlık zorunludur';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: "Açıklama",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Açıklama zorunludur';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: skillsController,
                    decoration: const InputDecoration(
                      labelText: "Yetenekler",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Yetenekler zorunludur';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Konum",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konum zorunludur';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: salaryController,
                    decoration: const InputDecoration(
                      labelText: "Maaş",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Maaş zorunludur';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir maaş girin';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateJob,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Güncelle", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

