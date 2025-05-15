import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:kariyer/db/database_helper.dart';

class ProfilDuzenlePage extends StatefulWidget {
  final UserModel user;

  const ProfilDuzenlePage({super.key, required this.user});

  @override
  State<ProfilDuzenlePage> createState() => _ProfilDuzenlePageState();
}

class _ProfilDuzenlePageState extends State<ProfilDuzenlePage> {
  late TextEditingController nameController;
  late TextEditingController skillsController;
  late TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();
  final phoneFormatter = MaskTextInputFormatter(
    mask: '(0###) ###-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    skillsController = TextEditingController(text: widget.user.skills);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;

      final updatedUser = UserModel(
        id: widget.user.id,
        name: nameController.text,
        skills: skillsController.text,
        phone: phoneController.text,
        email: widget.user.email,
        password: widget.user.password,
        userType: widget.user.userType,
      );

      await db.update(
        'users',
        {
          'name': updatedUser.name,
          'skills': updatedUser.skills,
          'phone': updatedUser.phone,
        },
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil güncellendi."),
          backgroundColor: Colors.green,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context, updatedUser); // ✅ Güncellenmiş kullanıcıyı geri gönder
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen alanları doğru şekilde doldurun."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenle', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad Soyad',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ad Soyad zorunludur';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Skills Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Yetenekler (Virgülle ayırın)',
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
                // Phone Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefon Numarası',
                        border: InputBorder.none,
                      ),
                      inputFormatters: [phoneFormatter],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefon numarası zorunludur';
                        }
                        if (value.length < 10) {
                          return 'Geçerli bir telefon numarası girin';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Save Button
                ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kaydet', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

