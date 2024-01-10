import 'package:flutter/material.dart';
import 'package:to_do_app/session_manager.dart';
import 'package:to_do_app/user_service.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newUsernameController = TextEditingController();

  void changePassword() async {
    bool success = await ApiService.changePassword(
      currentPasswordController.text,
      newPasswordController.text,
    );

    if (success) {
      // ignore: avoid_print
      print("Şifre başarıyla değiştirildi.");
    } else {

      // ignore: avoid_print
      print("Şifre değiştirme işlemi başarısız.");
    }
  }

  void changeUsername() async {
    bool success = await ApiService.changeUsername(newUsernameController.text);

    if (success) {
      // ignore: avoid_print
      print("Kullanıcı adı başarıyla değiştirildi.");
    } else {

      // ignore: avoid_print
      print("Kullanıcı adı değiştirme işlemi başarısız.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body:BottomBackgroundImage( child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kullanıcı Bilgileri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Kullanıcı Adı: ${SessionManager.loggedInUser?.nameUser ?? ""}'),
            const SizedBox(height: 16),
            const Text(
              'Şifre Değiştir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Mevcut Şifre'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                changePassword();
              },
              child: const Text('Şifreyi Değiştir'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kullanıcı Adını Değiştir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newUsernameController,
              decoration: const InputDecoration(labelText: 'Yeni Kullanıcı Adı'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                changeUsername();
              },
              child: const Text('Kullanıcı Adını Değiştir'),
            ),
          ],
        ),
      ),
    ),);
  }
}
