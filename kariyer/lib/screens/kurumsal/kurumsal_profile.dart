import 'package:flutter/material.dart';
import '../../models/user.dart';

class KurumsalProfilePage extends StatefulWidget {
  final UserModel user;
  const KurumsalProfilePage({super.key, required this.user});

  @override
  State<KurumsalProfilePage> createState() => _KurumsalProfilePageState();
}

class _KurumsalProfilePageState extends State<KurumsalProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController skillsController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    skillsController = TextEditingController(text: widget.user.skills);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kurumsal Profil"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                if (!isEditing) {
                  // Değişiklikleri kaydetme işlemi yapılabilir
                  // Veritabanı kaydı burada yapılabilir (isteğe bağlı)
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.business, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildProfileField("Şirket Adı", nameController),
            const SizedBox(height: 15),
            _buildProfileField("E-posta", emailController, readOnly: true),
            const SizedBox(height: 15),
            _buildProfileField("Uzmanlık Alanı", skillsController),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: readOnly || !isEditing,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: !isEditing || readOnly,
            fillColor: readOnly || !isEditing ? Colors.grey[200] : Colors.white,
          ),
        ),
      ],
    );
  }
}
