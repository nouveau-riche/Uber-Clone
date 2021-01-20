import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
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
              height: mq.height * 0.25,
              width: mq.width,
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            Text(
              'Login as a Rider',
              style: TextStyle(
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
                  buildEmailField(),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  buildPasswordField(),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  buildLoginButton(
                    mq.width * 0.7,
                  ),
                  buildRegisterButton(),
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
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        icon: Icon(CupertinoIcons.mail_solid,color: Colors.black54,),
        hintText: 'Email',
      ),
    );
  }

  Widget buildPasswordField() {
    return TextField(
      obscureText: true,
      cursorColor: Colors.black54,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusColor: Colors.black,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        icon: Icon(Icons.vpn_key,color: Colors.black54,),
        hintText: 'Password',
      ),
    );
  }

  Widget buildLoginButton(double width) {
    return SizedBox(
      width: width,
      child: RaisedButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textColor: Colors.white,
        color: Colors.yellow,
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Brand Bold',
          ),
        ),
      ),
    );
  }

  Widget buildRegisterButton(){
    return FlatButton(
      onPressed: () {},
      child: Text(
        'Do not have an Account? Register Here.',
        style: TextStyle(
          fontFamily: 'Brand Bold',
        ),
      ),
    );
  }

}
