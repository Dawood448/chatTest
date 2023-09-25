import 'package:chat_test/Views/home_screen.dart';
import 'package:chat_test/Views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
   Authenticate({super.key});
final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
   if (_auth.currentUser != null)
     {
      return HomeScreen();
     }
   else
     {
       return LoginScreen();

     }
  }
}
