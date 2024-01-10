import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BottomBackgroundImage(
            child: Center(
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 35.0),
                ),
            ),

          ),
        ));
  }
}