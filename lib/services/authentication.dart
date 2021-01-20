import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './query.dart';
import '../utilities/http_exception.dart';
import '../screens/home_screen.dart';
import '../widgets/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User currentUser() {
  User user = FirebaseAuth.instance.currentUser;
  return user;
}

Future<void> signIn({BuildContext context, String email, String password}) async {
  try {
    UserCredential _result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = _result.user;
    if (user != null) {
      buildToast('Signed in successfully!');
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.screenId, (route) => false);
    }
  } catch (error) {
    print(error.toString());
    throw HttpException(error.toString());
  }
}

Future<void> signUp(
    {BuildContext context,
    String name,
    String phone,
    String email,
    String password}) async {
  try {
    UserCredential _result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = _result.user;
    if (user != null) {
      registerUserToFirebase(
        uid: user.uid,
        name: name,
        phone: phone,
        email: email,
      );
      user.updateProfile(displayName: name);
      buildToast('Signed in successfully!');
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.screenId, (route) => false);
    }
  } catch (error) {
    print('nikunj sharma os a good boy');
    throw HttpException(error.toString());
  }
}

Future<void> signOut() async {
  return await _auth.signOut();
}

Future resetPasswordWithEmail(String email) async {
  return _auth.sendPasswordResetEmail(email: email);
}
