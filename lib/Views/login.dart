import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views//home.dart';
import 'package:seizure_deck/Views/create_account.dart';
import 'package:seizure_deck/data/user_data.dart';
import 'package:seizure_deck/database/loginDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late TextEditingController email;
  late TextEditingController password;
  bool isLoading = false;
  bool passwordVisible = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
  }

  late bool logincheck;

  // Function to handle navigation
  void _navigateToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                    mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                    children: [
                      Checkbox(
                        value: passwordVisible,
                        onChanged: (newValue) {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      Text("Show Password"),
                    ],
                  ),
                ),



                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Set loading state to true before API call
                    });

                    int? num;
                    num = await loginDBCheck(email, password);
                    // print(logincheck);

                    if (num != null) {
                      User user = User(uid: num);
                      Provider.of<UserProvider>(context,listen: false).setUser(user);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      showLoginResultDialog(logincheck);
                    }

                    setState(() {
                      isLoading = false; // Set loading state to false after the API call
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587)),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : const Text("Login",style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(context,
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
