
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_data_and_display/home_page.dart';
import 'package:get_data_and_display/login_or_register_page.dart';



class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logging in
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
