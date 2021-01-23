import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../services/config_map.dart';

final db = FirebaseFirestore.instance;

void registerUserToFirebase(
    {String uid, String name, String phone, String email}) {
  final ref = db.collection('users').doc(uid);
  ref.set({'uid': uid, 'name': name, 'phone': phone, 'email': email});
}

void saveRideRequest(BuildContext context, final ref) {
  var pickUp = Provider.of<DataProvider>(context,listen: false).pickUpLocation;
  var dropOff = Provider.of<DataProvider>(context,listen: false).dropOffLocation;

  Map pickUpMap = {
    'latitude': pickUp.latitude.toString(),
    'longitude': pickUp.longitude.toString(),
  };
  Map dropOffMap = {
    'latitude': dropOff.latitude.toString(),
    'longitude': dropOff.longitude.toString(),
  };

  ref.set({
    'driver_id': 'waiting',
    'payment_method': 'cash',
    'pickUp': pickUpMap,
    'dropOff': dropOffMap,
    'created_at': DateTime.now().toString(),
    'rider_name': user.name,
    'rider_phone': user.phone,
    'pickup_address': pickUp.placeName,
    'dropoff_address': dropOff.placeName
  });

  print(ref.id);

}

void deleteRideRequest(final ref) {
  ref.delete();
}
