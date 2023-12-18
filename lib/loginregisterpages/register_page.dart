import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_textboxes.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        showErrorMessage('Account Successfully Created');
      }else{
        Navigator.pop(context);
        showErrorMessage('Password Doesn\'t Match');
      }
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
                  if(message == 'Account Successfully Created'){
                    Navigator.pushNamed(context, '/loginpage');
                  }else{
                    Navigator.of(context).pop();
                  }
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
                  "Create An Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(238, 242, 230, 1.0),
                  ),
                ),
                Text(
                  "Sign up here",
                  style: TextStyle(
                    color: Color.fromRGBO(238, 242, 230, 1.0),
                  ),
                ),
                SizedBox(height: 20),
                MyTextBoxes(obscureText: false, controller: emailController, iconIn: Icons.email, name: 'Email',),
                MyTextBoxes(obscureText: true, controller: passwordController, iconIn: Icons.key, name: 'Password',),
                MyTextBoxes(obscureText: true, controller: confirmPasswordController, iconIn: Icons.key, name: 'Confirm Password',),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
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
                      signUserUp();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(320, 70),
                        backgroundColor: Color.fromRGBO(61, 131, 97, 1.0)),
                    child: Text(
                      'Sign up',
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
                      'Already have an account?',
                      style: TextStyle(
                        color: Color.fromRGBO(238, 242, 230, 1.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginpage');
                      },
                      child: Text(
                        'Login Here',
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