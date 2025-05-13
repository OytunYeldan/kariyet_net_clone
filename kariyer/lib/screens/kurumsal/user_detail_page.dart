import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcı: ${user.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ad Soyad: ${user.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Yetenekler: ${user.skills}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
