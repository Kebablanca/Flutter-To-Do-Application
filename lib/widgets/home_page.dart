import 'package:flutter/material.dart';
import 'package:to_do_app/auth.dart';
import 'package:to_do_app/user_model.dart';
import 'package:to_do_app/widgets/bottom_background_image.dart';
import 'package:to_do_app/widgets/menu.dart';
import 'package:to_do_app/widgets/signin.dart';

import '../session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uName = "";
  String pWord = "";
  String name = "";
  String uId = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BottomBackgroundImage(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.only(top: 100.0, left: 40.0, right: 40.0),
                      child: Image(
                        image: AssetImage(
                          "lib/assets/images/topbg.png",
                        ),
                        fit: BoxFit.cover,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50.0,
                          ),
                          const Text(
                            "Welcome",
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 212, 204, 204),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 26, 24, 24),
                                        width: 1)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            uName = value;
                                          });
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'UserName',
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 243, 236, 235)))))),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 212, 204, 204),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 26, 24, 24),
                                        width: 1)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      obscureText: true,
                                        onChanged: (value) {
                                          setState(() {
                                            pWord = value;
                                          });
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Password',
                                            hintStyle: TextStyle(                                              
                                                color: Color.fromARGB(
                                                    255, 243, 236, 235)))))),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final authService =
                                  AuthService('https://10.0.2.2:7163/api');
                              try {
                                bool result =
                                    await authService.postMethod(uName, pWord);
                                if (result) {
                                  // ignore: await_only_futures
                                  var value1 =
                                      await authService.getUserId(uName);
                                  var value2 = await authService.getName(uName);
                                  setState(() {
                                    uId = value1.toString();
                                    name = value2.toString();
                                  });
                                  UserMdl loggedInUser = UserMdl(
                                      userId: uId,
                                      nameUser:
                                          name); 
                                  SessionManager.setLoggedInUser(loggedInUser);

                                  // ignore: avoid_print
                                  print(loggedInUser.nameUser);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const Menu())));
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Hata'),
                                        content: const Text(
                                            'Kullanici adi veya sifre yanlis!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Tamam'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                setState(() {});
                              } catch (e) {
                                // ignore: avoid_print
                                print('Hata: $e');
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: const Color.fromARGB(255, 141, 108, 145),
                              ),
                              child: const Center(child: Text("Login")),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegistrationScreen()),
                              );
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
