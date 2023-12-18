import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_textboxes.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }

  }
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            backgroundColor: Color.fromRGBO(214, 205, 164, 1.0),
            title: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 103, 86, 1.0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note,
                  color: Color.fromRGBO(214, 205, 164, 1.0),
                  size: 130,
                ),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(238, 242, 230, 1.0),
                  ),
                ),
                Text(
                  "Listen again to your songs",
                  style: TextStyle(
                    color: Color.fromRGBO(238, 242, 230, 1.0),
                  ),
                ),
                SizedBox(height: 20),
                MyTextBoxes(
                  obscureText: false,
                  controller: emailController,
                  iconIn: Icons.email,
                  name: 'Email',
                ),
                MyTextBoxes(
                  obscureText: true,
                  controller: passwordController,
                  iconIn: Icons.key,
                  name: 'Password',
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 35, 0, 5),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(28, 103, 86, 1.0),
                      borderRadius: BorderRadius.circular(38),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(15, 80, 70, 1.0),
                          blurRadius: 15,
                          offset: Offset(5, 5),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(40, 125, 105, 1.0),
                          blurRadius: 10,
                          offset: Offset(-4, -4),
                        ),
                      ]),
                  child: ElevatedButton(
                    onPressed: () {
                      signUserIn();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(320, 70),
                        backgroundColor: Color.fromRGBO(61, 131, 97, 1.0)),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(214, 205, 164, 1.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No account yet?',
                      style: TextStyle(
                        color: Color.fromRGBO(238, 242, 230, 1.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registerpage');
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                          color: Color.fromRGBO(214, 205, 164, 1.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
