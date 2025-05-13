import 'package:flutter/material.dart';
import 'package:kariyer/screens/bireysel/bireysel_home.dart';
import '../../db/database_helper.dart';
import '../../models/user.dart';
import '../kurumsal/kurumsal_home.dart';
import 'register_page.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG desteği için eklendi

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form doğrulama için GlobalKey

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) { // Form doğrulamasını kontrol et
      final db = await DatabaseHelper().database;
      final result = await db.query('users',
          where: 'email = ? AND password = ?',
          whereArgs: [emailController.text, passwordController.text]);

      if (result.isNotEmpty) {
        final user = UserModel.fromMap(result.first);
        if (user.userType == 'bireysel') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BireyselHomePage(user: user)));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KurumsalHomePage(user: user)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hatalı e-posta veya şifre."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Arka plan rengi
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Form widget'ı eklendi
            key: _formKey, // GlobalKey atandı
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo veya karşılama görseli
                SvgPicture.asset(
                  'assets/login_logo.svg', // Örnek bir SVG dosyası.  Bunu kendi logonuzla değiştirin.
                  height: 100, // Logo yüksekliği
                  // ignore: deprecated_member_use
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  "Hoş Geldiniz", // Karşılama mesajı
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
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Giriş Yap Butonu
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor, // Temanın birincil rengini kullanır
                  ),
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                // Kayıt Ol Butonu
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: Text(
                    "Hesabınız yok mu? Kayıt Olun",
                    style: TextStyle(color: Theme.of(context).primaryColor),
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

