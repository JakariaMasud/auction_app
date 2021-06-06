import 'package:auction_app/Helpers/size_config.dart';
import 'package:auction_app/screens/home_screen.dart';
import 'package:auction_app/screens/login_screen.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuthService.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          SizeConfig().init(context);
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            return user != null ? HomeScreen() : LoginScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
