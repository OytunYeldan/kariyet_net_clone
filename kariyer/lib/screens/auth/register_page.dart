import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController(); // 📞 Telefon alanı
  final skillsController = TextEditingController();

  String userType = 'bireysel';

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;

      final newUser = UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userType: userType,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(), // Telefon eklendi
        skills: skillsController.text.trim(),
      );

      await db.insert('users', newUser.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarılı."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Giriş sayfasına dön
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose(); // temizle
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text("Kayıt Ol"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SvgPicture.asset(
                  'assets/register_logo.svg',
                  height: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // E-posta
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration("E-posta", Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Lütfen e-posta girin.';
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
                      return 'Geçerli bir e-posta girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Şifre
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: inputDecoration("Şifre", Icons.lock),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Lütfen şifre girin.';
                    if (value.length < 6) return 'Şifre en az 6 karakter olmalı.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ad Soyad / Şirket Adı
                TextFormField(
                  controller: nameController,
                  decoration: inputDecoration("Ad Soyad / Şirket Adı", Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Lütfen ad/şirket adını girin.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Telefon Numarası
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration("Telefon Numarası", Icons.phone),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Lütfen telefon numarası girin.';
                    if (value.length < 10) return 'Geçerli bir telefon numarası girin.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Yetenekler
                TextFormField(
                  controller: skillsController,
                  decoration: inputDecoration("Yetenekler (virgülle)", Icons.star),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Lütfen yetenekleri girin.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kullanıcı Tipi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: userType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          userType = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'bireysel', child: Text("Bireysel")),
                      DropdownMenuItem(value: 'kurumsal', child: Text("Kurumsal")),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Kullanıcı Tipi",
                      prefixIcon: Icon(Icons.person_pin),
                      border: InputBorder.none,
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Lütfen kullanıcı tipi seçin.' : null,
                  ),
                ),

                const SizedBox(height: 32),

                // Kayıt Butonu
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
