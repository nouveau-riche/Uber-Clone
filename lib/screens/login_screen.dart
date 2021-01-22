import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './signup_screen.dart';
import '../widgets/toast.dart';
import '../utilities/http_exception.dart';
import '../services/authentication.dart';
import '../widgets/progressDialog.dart';

class LoginScreen extends StatelessWidget {
  static const screenId = './login_screen';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * 0.08,
            ),
            Image.asset(
              'assets/images/logo.png',
              height: mq.height * 0.28,
              width: mq.width,
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            const Text(
              'Login as a Rider',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Brand Bold',
              ),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildEmailField(),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  buildPasswordField(),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  buildLoginButton(mq.width * 0.7, context),
                  buildGoToSignUpPageButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black54,
      decoration: const InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.black)),
        icon: const Icon(
          Icons.email,
          color: Colors.black54,
        ),
        hintText: 'Email',
        hintStyle: const TextStyle(fontFamily: 'Brand-Regular'),
      ),
      controller: _emailController,
    );
  }

  Widget buildPasswordField() {
    return TextField(
      obscureText: true,
      cursorColor: Colors.black54,
      decoration: const InputDecoration(
        focusColor: Colors.black,
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        icon: const Icon(
          Icons.vpn_key,
          color: Colors.black54,
        ),
        hintText: 'Password',
        hintStyle: const TextStyle(fontFamily: 'Brand-Regular'),
      ),
      controller: _passwordController,
    );
  }

  Widget buildLoginButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: RaisedButton(
        onPressed: () async {
          try {
            showDialog(
                context: context,
                builder: (context) {
                  return ProgressDialog('Signing in..');
                });

            if (!_emailController.text.contains('@') ||
                _emailController.text.length <= 5) {
              buildToast('Enter Correct Email');
              return;
            }
            await signIn(
                context: context,
                email: _emailController.text,
                password: _passwordController.text);
          } on HttpException catch (error) {
            Navigator.of(context).pop();
            var errorMessage = 'Failed! Try again Later';

            if (error.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
              errorMessage = 'Too many requests. Try again Later!';
            } else if (error.toString().contains(
                'password is invalid or the user does not have a password')) {
              errorMessage = 'Wrong Password';
            } else if (error.toString().contains(
                'There is no user record corresponding to this identifier')) {
              errorMessage = 'User not found! Create new Account';
            }
            buildToast(errorMessage);
          } catch (error) {
            Navigator.of(context).pop();
            const errorMessage = 'Internet connection too slow';
            buildToast(errorMessage);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textColor: Colors.white,
        color: Colors.yellow,
        child: const Text(
          'Login',
          style: const TextStyle(
            fontSize: 17,
            fontFamily: 'Brand Bold',
          ),
        ),
      ),
    );
  }

  Widget buildGoToSignUpPageButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (ctx) => SignUpScreen()),
            (route) => false);
      },
      child: const Text(
        'Do not have an Account? Register Here.',
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Brand-Regular',
        ),
      ),
    );
  }
}
