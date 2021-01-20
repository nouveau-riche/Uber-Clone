import 'package:flutter/material.dart';

import '../services/authentication.dart';
import '../screens/login_screen.dart';

Widget buildDrawer(BuildContext context) {
  final mq = MediaQuery.of(context).size;

  return ListView(
    children: [
      DrawerHeader(
          child: Container(
            height: mq.height * 0.03,
            child: Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black38,
                ),
                const SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Profile Name',
                      style: const TextStyle(
                          fontFamily: 'Brand Bold', fontSize: 17),
                    ),
                    const Text(
                      'Visit Profile',
                      style: const TextStyle(
                          fontFamily: 'Brand Bold', fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          curve: Curves.fastOutSlowIn),
      buildDrawerListTile('History', const Icon(Icons.history)),
      buildDrawerListTile('Visit Profile', const Icon(Icons.person)),
      buildDrawerListTile('About', const Icon(Icons.info)),
      GestureDetector(
          onTap: () {
            signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.screenId, (route) => false);
          },
          child: buildDrawerListTile('Log Out', const Icon(Icons.logout))),
    ],
  );
}

Widget buildDrawerListTile(String title, Icon icon) {
  return ListTile(
    leading: icon,
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'Brand Bold'),
    ),
  );
}
