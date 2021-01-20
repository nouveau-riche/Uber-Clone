import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

void registerUserToFirebase({
    String uid, String name, String phone, String email}) {
  final ref = db.collection('users').doc(uid);
  ref.set({'uid': uid, 'name': name, 'phone': phone, 'email': email});
}
