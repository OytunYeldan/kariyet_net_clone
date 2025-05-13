import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/user.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG desteği için eklendi

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final skillsController = TextEditingController();
  String userType = 'bireysel';
  final _formKey = GlobalKey<FormState>(); // Form doğrulama için GlobalKey

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) { // Form doğrulamasını kontrol et
      final db = await DatabaseHelper().database;

      final newUser = UserModel(
        email: emailController.text,
        password: passwordController.text,
        userType: userType,
        name: nameController.text,
        skills: skillsController.text,
      );

      await db.insert('users', newUser.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarılı."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Arka plan rengi
      appBar: AppBar(
        title: const Text("Kayıt Ol"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Form widget'ı eklendi
            key: _formKey, // GlobalKey atandı
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // Logo veya kayıt görseli
                SvgPicture.asset(
                  'assets/register_logo.svg', // Örnek bir SVG dosyası. Bunu kendi logonuzla değiştirin.
                  height: 100, // Logo yüksekliği
                  // ignore: deprecated_member_use
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
                // E-posta TextField
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-posta",
                    hintText: "E-posta adresinizi girin",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen e-posta adresinizi girin.';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Şifre TextField
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    hintText: "Şifrenizi girin",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin.';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Ad Soyad / Şirket Adı TextField
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Ad Soyad / Şirket Adı",
                    hintText: "Adınızı ve soyadınızı veya şirket adınızı girin",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adınızı ve soyadınızı veya şirket adınızı girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Yetenekler TextField
                TextFormField(
                  controller: skillsController,
                  decoration: InputDecoration(
                    labelText: "Yetenekler (virgülle ayrılmış)",
                    hintText: "Yeteneklerinizi virgülle ayırarak girin (Örn: Java, C++, Python)",
                    prefixIcon: const Icon(Icons.star),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen yeteneklerinizi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Kullanıcı Tipi Dropdown
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
                      border: InputBorder.none, // DropdownButtonFormField için border kaldırıldı
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Lütfen kullanıcı tipini seçin.' : null,
                  ),
                ),
                const SizedBox(height: 32),
                // Kayıt Ol Butonu
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor, // Temanın birincil rengini kullanır
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
}

