import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'ilan_ara.dart';
import 'eslesen_ilanlar.dart';
import 'bireysel_profile.dart';

class BireyselHomePage extends StatefulWidget {
  final UserModel user;

  const BireyselHomePage({super.key, required this.user});

  @override
  State<BireyselHomePage> createState() => _BireyselHomePageState();
}

class _BireyselHomePageState extends State<BireyselHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      IlanlarPage(user: widget.user),
      EslesenIlanlarPage(user: widget.user),
      ProfilDuzenlePage(user: widget.user),
    ];

    return Scaffold(
      // AppBar'ı tamamen kaldırdım
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'İlanlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Eşleşen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
