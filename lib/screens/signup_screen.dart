import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './login_screen.dart';
import '../services/authentication.dart';
import '../utilities/http_exception.dart';
import '../widgets/toast.dart';
import '../widgets/progressDialog.dart';

class SignUpScreen extends StatelessWidget {
  static const screenId = './signup_screen';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
              'Register as a Rider',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Brand Bold',
              ),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildNameField(),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  buildPhoneNumberField(),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  buildEmailField(),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  buildPasswordField(),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  buildSignUpButton(mq.width * 0.7, context),
                  buildGoToLoginPageButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextField(
      cursorColor: Colors.black54,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        focusedBorder:
            const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        icon: const Icon(
          Icons.person,
          color: Colors.black54,
        ),
        hintText: 'Name',
        hintStyle: const TextStyle(fontFamily: 'Brand-Regular'),
      ),
      controller: _nameController,
    );
  }

  Widget buildPhoneNumberField() {
    return TextField(
      cursorColor: Colors.black54,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        focusedBorder:
            const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.black)),
        icon: const Icon(
          Icons.phone,
          color: Colors.black54,
        ),
        hintText: 'Phone',
        hintStyle: const TextStyle(fontFamily: 'Brand-Regular'),
      ),
      controller: _phoneController,
    );
  }

  Widget buildEmailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black54,
      decoration: const InputDecoration(
        focusedBorder:
            const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.black)),
        icon: Icon(
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
        focusedBorder:
        const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.black)),
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

  Widget buildSignUpButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: RaisedButton(
        onPressed: () async {
          try {
            if (_passwordController.text.length <= 5) {
              buildToast('Password length should be more than 5');
              return;
            } else if (_nameController.text.length <= 1) {
              buildToast('name length should be more than 21');
              return;
            } else if (!_emailController.text.contains('@') ||
                _emailController.text.length <= 5) {
              buildToast('Enter Correct Email');
              return;
            } else if (_phoneController.text.length != 10) {
              buildToast('Enter Correct Phone number');
              return;
            }

            showDialog(context: context,builder: (context){
              return ProgressDialog('Signing in..');
            });

            await signUp(
                context: context,
                name: _nameController.text,
                phone: _phoneController.text,
                email: _emailController.text,
                password: _passwordController.text);
          } on HttpException catch (error) {
            Navigator.of(context).pop();
            var errorMessage = 'Failed! Try again Later';

            if (error.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
              errorMessage = 'Too many requests. Try again Later!';
            } else if (error.toString().contains(
                'The email address is already in use by another account')) {
              errorMessage = 'User Already Registered';
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
          'Register',
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Brand Bold',
          ),
        ),
      ),
    );
  }

  Widget buildGoToLoginPageButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (ctx) => LoginScreen()),
            (route) => false);
      },
      child: const Text(
        'Already have an Account? Login Here.',
        style: const TextStyle(
          fontFamily: 'Brand Bold',
        ),
      ),
    );
  }
}
