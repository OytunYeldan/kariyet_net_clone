import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<Map<String, dynamic>> _applications = [];
  List<Map<String, dynamic>> _jobApplicationStats = [];
  List<Map<String, dynamic>> _applicationLogs = [];

  int bireyselCount = 0;
  int kurumsalCount = 0;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final db = await DatabaseHelper().database;

    final userList = await db.query('users');
    final jobList = await db.query('jobs');
    final applicationList = await db.query('applications');

    final stats = await db.rawQuery('''
      SELECT jobs.id, jobs.title, COUNT(applications.id) as applicationCount
      FROM jobs
      LEFT JOIN applications ON jobs.id = applications.jobId
      GROUP BY jobs.id
    ''');

    final logs = await db.rawQuery('''
      SELECT users.name as userName, users.userType, jobs.title as jobTitle
      FROM applications
      INNER JOIN users ON applications.userId = users.id
      INNER JOIN jobs ON applications.jobId = jobs.id
    ''');

    bireyselCount = userList.where((u) => u['userType'] == 'bireysel').length;
    kurumsalCount = userList.where((u) => u['userType'] == 'kurumsal').length;

    setState(() {
      _users = userList;
      _jobs = jobList;
      _applications = applicationList;
      _jobApplicationStats = stats;
      _applicationLogs = logs;
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

  double getMaxY() {
    int maxY = 0;
    for (var stat in _jobApplicationStats) {
      final count = (stat['applicationCount'] ?? 0) as int;
      if (count > maxY) maxY = count;
    }
    return (maxY + 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      buildJobsTab(),
      buildUsersTab(),
      buildStatsTab(),
      buildApplicationsTab(),
    ];

    return Scaffold(
      body: SafeArea(child: tabs[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "İlanlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Kullanıcılar"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "İstatistik"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Başvurular"),
        ],
      ),
    );
  }

  Widget buildJobsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(job['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.all(12),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(user['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: Colors.blue[50],
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("📊 Genel İstatistikler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                  const SizedBox(height: 12),
                  Text("👤 Toplam Kullanıcı: ${_users.length}", style: const TextStyle(fontSize: 15)),
                  Text("➡️ Bireysel: $bireyselCount", style: const TextStyle(fontSize: 15)),
                  Text("🏢 Kurumsal: $kurumsalCount", style: const TextStyle(fontSize: 15)),
                  Text("📝 Toplam İlan: ${_jobs.length}", style: const TextStyle(fontSize: 15)),
                  Text("📥 Toplam Başvuru: ${_applications.length}", style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text("İlan Başına Başvuru Sayısı", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: getMaxY(),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < _jobApplicationStats.length) {
                            final title = _jobApplicationStats[index]['title'] ?? '';
                            return Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                title.length > 10 ? "${title.substring(0, 10)}..." : title,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _jobApplicationStats.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    final count = (stat['applicationCount'] ?? 0) as int;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: Colors.blueAccent,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApplicationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _applicationLogs.length,
      itemBuilder: (context, index) {
        final log = _applicationLogs[index];
        final userName = log['userName'] ?? '';
        final userType = log['userType'] ?? '';
        final jobTitle = log['jobTitle'] ?? '';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.blueAccent),
            title: Text("$userName → $jobTitle", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Kullanıcı Tipi: $userType"),
          ),
        );
      },
    );
  }
}
