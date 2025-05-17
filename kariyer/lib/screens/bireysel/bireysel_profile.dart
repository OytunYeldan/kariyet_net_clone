import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:kariyer/db/database_helper.dart';

class BireyselProfilPage extends StatefulWidget {
  final UserModel user;

  const BireyselProfilPage({super.key, required this.user});

  @override
  State<BireyselProfilPage> createState() => _BireyselProfilPageState();
}

class _BireyselProfilPageState extends State<BireyselProfilPage> {
  late TextEditingController nameController;
  late TextEditingController skillsController;
  late TextEditingController phoneController;

  final _formKey = GlobalKey<FormState>();
  final phoneFormatter = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  late int userId;

  @override
  void initState() {
    super.initState();

    userId = widget.user.id!;
    nameController = TextEditingController(text: widget.user.name);
    skillsController = TextEditingController(text: widget.user.skills);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper().database;

    // DB güncelle
    await db.update(
      'users',
      {
        'name': nameController.text.trim(),
        'skills': skillsController.text.trim(),
        'phone': phoneController.text.trim(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );

    // DB'den tekrar veriyi çek ve UI'ı güncelle
    final List<Map<String, dynamic>> updatedUserMapList = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (updatedUserMapList.isNotEmpty) {
      final updatedUserMap = updatedUserMapList.first;

      setState(() {
        nameController.text = updatedUserMap['name'] ?? '';
        skillsController.text = updatedUserMap['skills'] ?? '';
        phoneController.text = updatedUserMap['phone'] ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil başarıyla güncellendi."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Güncellenmiş profil bulunamadı."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    skillsController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenle'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Ad Soyad zorunludur' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: skillsController,
                decoration: const InputDecoration(
                  labelText: 'Yetenekler (Virgülle ayırın)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Yetenekler zorunludur' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [phoneFormatter],
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Telefon numarası zorunludur';
                  }
                  final digitsOnly = val.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly.length < 10) {
                    return 'Geçerli bir telefon numarası girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
