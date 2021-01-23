import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberrider/models/direction_detail.dart';

import '../services/http_request.dart';
import '../provider/provider.dart';
import '../models/address_model.dart';
import '../services/config_map.dart';

class MapMethods {
  static Future<String> getAddressFromCoordinates(
      Position position, BuildContext context) async {
    String placeAddress = '';

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    placeAddress = first.addressLine;

    AddressModel userPickUpAddress = new AddressModel();
    userPickUpAddress.longitude = position.longitude;
    userPickUpAddress.latitude = position.latitude;
    userPickUpAddress.placeName = placeAddress;

    Provider.of<DataProvider>(context, listen: false)
        .updatePickUpLocationAddress(userPickUpAddress);

    return placeAddress;
  }

  static Future<DirectionDetail> getPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey';

    var res = await HttpMethods.getRequest(directionUrl);

    if (res == 'failed') {
      return null;
    }

    DirectionDetail directionDetail = DirectionDetail();

    directionDetail.encodePoints =
        res['routes'][0]['overview_polyline']['points'];

    directionDetail.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];
    directionDetail.distanceValue =
        res['routes'][0]['legs'][0]['distance']['value'];

    directionDetail.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];
    directionDetail.durationValue =
        res['routes'][0]['legs'][0]['duration']['value'];

    return directionDetail;
  }

  static int calculateFares(DirectionDetail directionDetail) {
    double timeTravelFare = (directionDetail.durationValue / 60) * 10;
    double distanceTraveledFare = (directionDetail.distanceValue / 1000) * 10;

    double totalFare = timeTravelFare + distanceTraveledFare;

    return totalFare.truncate();
  }
}
