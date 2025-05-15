import 'package:flutter/material.dart';
import '../../db/database_helper.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final db = await DatabaseHelper().database;
    final userList = await db.query('users');
    final jobList = await db.query('jobs');

    setState(() {
      _users = userList;
      _jobs = jobList;
    });
  }

  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    fetchAllData();
  }

  Future<void> deleteJob(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
    fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      buildJobsTab(),
      buildUsersTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Paneli"),
        centerTitle: true,
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Tüm İlanlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tüm Kullanıcılar"),
        ],
      ),
    );
  }

  Widget buildJobsTab() {
    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(job['title'] ?? ''),
            subtitle: Text(job['description'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteJob(job['id']),
            ),
          ),
        );
      },
    );
  }

  Widget buildUsersTab() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(user['name'] ?? ''),
            subtitle: Text('${user['email']} - ${user['userType']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteUser(user['id']),
            ),
          ),
        );
      },
    );
  }
}
