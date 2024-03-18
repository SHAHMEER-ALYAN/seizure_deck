import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views/create_account.dart';
import 'package:seizure_deck/data/theme.dart';
import 'package:seizure_deck/data/user_data.dart';
import 'package:seizure_deck/database/loginDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>  {
  late TextEditingController email;
  late TextEditingController password;
  bool isLoading = false;
  bool passwordVisible = false;
  bool rememberME = false;
  late SharedPreferences prefs;

  @override
  initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    requestPermissions();
    checkRememberMe();
    // initialization();
    // OverAlerawaittWin();
    // OverAlerawaittWin();
  }

  late bool logincheck;

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  }

  Future<void> checkRememberMe()async {
    prefs = await SharedPreferences.getInstance();
    int? storedID = prefs.getInt("RememberMe");
    if(storedID!=null){
      prefs.setInt("uid", storedID);
      User user = User(uid: storedID);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      _navigateToHome(context);
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeManager.lightTheme,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Image.asset(
                    'assets/slogo.png',
                    height: 300,
                  ),
                ),
                const Text(
                  "Email",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 5, color: Color(0xFF454587))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 5, color: Color(0xFF454587))),
                        hintText: "Email"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Password",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    controller: password,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: passwordVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587)),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 5, color: Color(0xFF454587))),
                        hintText: "Password"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      Checkbox(
                        value: rememberME,
                        onChanged: (newValue) {
                          setState(() {
                            rememberME = !rememberME;
                          });
                          print(rememberME);
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading =
                          true; 
                    });
                    prefs = await SharedPreferences.getInstance();
                    dynamic num;
                    num = await loginDBCheck(email, password);
                    
                    if (num.runtimeType == int) {
                      if (num != null) {
                        User user = User(uid: num);
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(user);
                        prefs.setInt("uid", user.uid);
                        if(rememberME == true) {
                          prefs.setInt("RememberMe", user.uid);
                          print("Shared Preferences Working : ${prefs.getInt(
                              "RememberMe")}");
                        }
                        setState(() {
                          isLoading =
                          false; 
                        });
                        _navigateToHome(context);
                      }
                    } else {
                      print(num.toString());
                      Fluttertoast.showToast(
                          msg: num.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.purple.shade200,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587)),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Login",
                          style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const create_account()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF454587)),
                    child: const Text("Create Account")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showLoginResultDialog(bool logincheck) async {
    String message;
    if (logincheck == true) {
      message = "Login successful";
    } else {
      message = "Wrong password or email not found";
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Result"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
//
// @pragma("vm:entry-point")
// void overlayMain() {
//   runApp(const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Material(child: Text("My overlay"))
//   ));
// }
//
// OverAlerawaittWin() async {
//   await SystemAlertWindow.showSystemWindow();
//
// }


void initialization() async {
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  Remove the following example because
  // delaying the user experience is a bad design practice!
  // ignore_for_file: avoid_print
  print('ready in 3...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 2...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 1...');
  await Future.delayed(const Duration(seconds: 1));
  print('go!');
  FlutterNativeSplash.remove();
}
Future<void> requestPermissions() async {

  // await SystemAlertWindow.requestPermissions;

  // Ask for location permission
  await Permission.location.request();

  // Ask for notification permission
  await Permission.notification.request();

  // Ask for phone permission
  await Permission.phone.request();

  // Ask for SMS permission
  await Permission.sms.request();
}