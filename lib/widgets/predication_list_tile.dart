import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberrider/provider/provider.dart';

import '../models/address_model.dart';
import '../services/config_map.dart';
import '../models/place_predication.dart';
import '../services/http_request.dart';
import '../widgets/progressDialog.dart';

class PredicationListTile extends StatelessWidget {
  final PlacePredication placePredication;

  PredicationListTile(this.placePredication);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        getPlaceDetails(placePredication.placeId, context);
      },
      dense: true,
      leading: Icon(
        Icons.add_location,
        color: Colors.grey,
        size: 30,
      ),
      title: Text(
        placePredication.mainText,
        style: TextStyle(fontSize: 16, fontFamily: 'Brand Bold'),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        placePredication.secondaryText,
        style: TextStyle(color: Colors.grey, fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => ProgressDialog('Setting DropOff,Please wait...'),
    );

    String placesAddressUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';

    var res = await HttpMethods.getRequest(placesAddressUrl);

    Navigator.of(context).pop();

    if (res == 'failed') {
      return;
    }

    if (res['status'] == 'OK') {
      AddressModel model = AddressModel();
      model.placeId = placeId;
      model.placeName = res['result']['name'];
      model.latitude = res['result']['geometry']['location']['lat'];
      model.longitude = res['result']['geometry']['location']['lng'];

      Provider.of<DataProvider>(context,listen: false).updateDropOffLocationAddress(model);

      Navigator.of(context).pop('obtainedDirection');
    }
  }
}
