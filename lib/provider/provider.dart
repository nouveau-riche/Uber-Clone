import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address_model.dart';

class DataProvider extends ChangeNotifier {
  AddressModel pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(AddressModel pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(AddressModel dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
