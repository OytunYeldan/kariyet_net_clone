import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'kurumsal_profile.dart';
import 'ilanlar_page.dart';
import 'basvuranlar.dart';

class KurumsalHomePage extends StatefulWidget {
  final UserModel user;
  const KurumsalHomePage({super.key, required this.user});

  @override
  State<KurumsalHomePage> createState() => _KurumsalHomePageState();
}

class _KurumsalHomePageState extends State<KurumsalHomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      IlanlarPage(user: widget.user),
      BasvuranlarPage(user: widget.user),
      KurumsalProfilePage(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "İlanlarım"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Başvuranlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
