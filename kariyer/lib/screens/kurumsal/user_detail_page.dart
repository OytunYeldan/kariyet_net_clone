import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user.dart';
import '../../models/job.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user;
  final JobModel job;

  const UserDetailPage({super.key, required this.user, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı: ${user.name}", style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInformation(context, user),
              const SizedBox(height: 20),

              // Telefon Et Butonu
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(user.phone),
                  icon: const Icon(Icons.phone),
                  label: const Text('Telefon Et'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Randevu Ver Butonu
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _selectDateAndSendSMS(context, user, job),
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Randevu Ver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInformation(BuildContext context, UserModel user) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(context, "Ad Soyad", user.name),
            const Divider(color: Colors.grey),
            _buildInfoRow(context, "Email", user.email),
            const Divider(color: Colors.grey),
            _buildInfoRow(context, "Yetenekler", user.skills),
            const Divider(color: Colors.grey),
            _buildInfoRow(context, "Telefon", user.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    List<String> parts = value.split(',');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: parts.map((part) {
                return Text(
                  part.trim(),
                  style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
                  textAlign: TextAlign.left,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Telefon araması başlatılamadı: $phoneNumber';
    }
  }

  void _selectDateAndSendSMS(BuildContext context, UserModel user, JobModel job) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      final formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);

      final message =
          "Sayın ${user.name}, $formattedDate tarihinde saat 09.00-12.00 arası ${job.title} için ${job.location} adresine görüşmeye bekleriz.";

      final smsUrl = Uri.parse("sms:${user.phone}?body=${Uri.encodeComponent(message)}");

      if (await canLaunchUrl(smsUrl)) {
        await launchUrl(smsUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("SMS uygulaması açılamadı")),
        );
      }
    }
  }
}
