import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String name;
  String phone;
  String email;

  Users({this.id, this.name, this.phone, this.email});

  Users.fromSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.data()['uid'];
    name = documentSnapshot.data()['name'];
    email = documentSnapshot.data()['email'];
    phone = documentSnapshot.data()['phone'];
  }
}
