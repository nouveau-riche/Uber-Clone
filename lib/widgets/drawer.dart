import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context) {
  final mq = MediaQuery.of(context).size;

  return ListView(
    children: [
      DrawerHeader(
          child: Container(
            height: mq.height * 0.03,
            child: Row(
              children: [
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black38,
                ),
                SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Profile Name',
                      style: TextStyle(fontFamily: 'Brand Bold', fontSize: 17),
                    ),
                    Text(
                      'Visit Profile',
                      style: TextStyle(fontFamily: 'Brand Bold', fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          curve: Curves.fastOutSlowIn),
      buildDrawerListTile('History', Icon(Icons.history)),
      buildDrawerListTile('Visit Profile', Icon(Icons.person)),
      buildDrawerListTile('About', Icon(Icons.info)),
    ],
  );
}

Widget buildDrawerListTile(String title, Icon icon) {
  return ListTile(
    leading: icon,
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Brand Bold'),
    ),
  );
}
