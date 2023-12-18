import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: Color.fromRGBO(236, 227, 206, 1.0),
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'MeloPlayer',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Log out',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: (){
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          )),
    );
  }
}