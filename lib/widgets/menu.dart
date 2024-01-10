import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';
import 'package:to_do_app/widgets/clock.dart';
import 'package:to_do_app/widgets/myplans.dart';
import 'package:to_do_app/widgets/profile.dart';
import 'package:to_do_app/widgets/settings.dart';

import '../session_manager.dart';
import '../user_model.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    UserMdl? currentUser = SessionManager.loggedInUser;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BottomBackgroundImage(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 120),
                Text(
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(207, 158, 17, 123)),
                    "Welcome ${currentUser?.nameUser.toUpperCase()}"),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Profile())));
                        },
                        child: Image.asset(
                          "lib/assets/images/profile.png",
                          width: 110,
                          height: 110,
                        ),
                      ),
                      const Text("Profile")
                    ]),
                    const SizedBox(width: 100),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Clock())));
                        },
                        child: Image.asset(
                          "lib/assets/images/clock.png",
                          width: 110,
                          height: 110,
                        ),
                      ),
                      const Text("Clock")
                    ]),
                  ],
                ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 15),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const MyPlans())));
                        },
                        child: Image.asset(
                          "lib/assets/images/myplans.png",
                          width: 110,
                          height: 110,
                        ),
                      ),
                      const Text("My Plans")
                    ]),
                    const SizedBox(width: 100),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const SettingsPage())));
                        },
                        child: Image.asset(
                          "lib/assets/images/settingsicon.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const Text("Settings")
                    ]),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
