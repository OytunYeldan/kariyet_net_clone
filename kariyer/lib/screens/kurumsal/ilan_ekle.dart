import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../db/database_helper.dart';

class IlanEklePage extends StatefulWidget {
  final UserModel user;
  const IlanEklePage({super.key, required this.user});

  @override
  State<IlanEklePage> createState() => _IlanEklePageState();
}

class _IlanEklePageState extends State<IlanEklePage> {
  final _formKey = GlobalKey<FormState>(); // Added form key for validation
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final skillsController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();

  Future<void> saveJob() async {
    if (_formKey.currentState!.validate()) { // Use form validation
      final job = JobModel(
        title: titleController.text,
        description: descController.text,
        skills: skillsController.text,
        companyId: widget.user.id.toString(),
        location: locationController.text,
        salary: salaryController.text,
      );

      final db = await DatabaseHelper().database;
      await db.insert('jobs', job.toMap());
      if (mounted) {
        Navigator.pop(context); // geri dön
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni İlan Ekle", style: TextStyle(color: Colors.white)), // Consistent AppBar title
        backgroundColor: Theme.of(context).primaryColor, // Consistent AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Added Form widget
          key: _formKey,
          child: ListView(
            children: [
              Card( // Added Card for styling
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Başlık",
                      border: InputBorder.none, // Removed border
                    ),
                    validator: (value) {  // Added validator
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
                onPressed: saveJob,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Kaydet", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

