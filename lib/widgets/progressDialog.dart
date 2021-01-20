import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;

  ProgressDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
      backgroundColor: Colors.yellow,
      child: Container(
        height: 70,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
         borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              message,
              style: TextStyle(fontFamily: 'Brand-Regular',fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
