import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/user.dart';

class ProfilDuzenlePage extends StatefulWidget {
  final UserModel user;

  const ProfilDuzenlePage({super.key, required this.user});

  @override
  State<ProfilDuzenlePage> createState() => _ProfilDuzenlePageState();
}

class _ProfilDuzenlePageState extends State<ProfilDuzenlePage> {
  late TextEditingController nameController;
  late TextEditingController skillsController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    skillsController = TextEditingController(text: widget.user.skills);
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      await db.update(
        'users',
        {
          'name': nameController.text,
          'skills': skillsController.text,
        },
        where: 'id = ?',
        whereArgs: [widget.user.id],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil güncellendi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: skillsController,
                decoration: const InputDecoration(labelText: 'Yetenekler'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
