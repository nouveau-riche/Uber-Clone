import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uberrider/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/login_screen.dart';
import './screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? HomeScreen.screenId
          : LoginScreen.screenId,
      routes: {
        LoginScreen.screenId: (ctx) => LoginScreen(),
        SignUpScreen.screenId: (ctx) => SignUpScreen(),
        HomeScreen.screenId: (ctx) => HomeScreen(),
      },
    );
  }
}
