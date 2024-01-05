import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views//home.dart';
import 'package:seizure_deck/Views/create_account.dart';
import 'package:seizure_deck/data/theme.dart';
import 'package:seizure_deck/data/user_data.dart';
import 'package:seizure_deck/database/loginDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    checkRememberMe();
  }

  late bool logincheck;

  // Function to handle navigation
  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<void> checkRememberMe()async {
    prefs = await SharedPreferences.getInstance();
    int? storedID = prefs.getInt("RememberMe");
    if(storedID!=null){
      User user = User(uid: storedID);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      _navigateToHome(context);
      // dispose();
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
                // Scrollable(viewportBuilder: AxisDirection.down),
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
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
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
                    // Center the content horizontally
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
                      Text("Remember Me"),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading =
                          true; // Set loading state to true before API call
                    });
                    prefs = await SharedPreferences.getInstance();
                    dynamic? num;
                    num = await loginDBCheck(email, password);
                    // print(num);
                    if (num.runtimeType == int) {
                      if (num != null) {
                        User user = User(uid: num);
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(user);
                        if(rememberME == true) {
                          prefs.setInt("RememberMe", user.uid);
                          print("Shared Preferences Working ? ${prefs.getInt(
                              "RememberMe")}");
                        }
                        setState(() {
                          isLoading =
                          false; // Set loading state to true before API call
                        });
                        _navigateToHome(context);
                        // setState(() {
                        //   isLoading =
                        //       false; // Set loading state to true before API call
                        // });
                        // dispose();
                      }
                    } else {
                      // setState(() {
                      //   isLoading = false;
                      // });
                      showLoginResultDialog(logincheck);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587)),
                  child: isLoading
                      ? CircularProgressIndicator()
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
                              builder: (context) => create_account()));
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
          title: Text("Login Result"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
