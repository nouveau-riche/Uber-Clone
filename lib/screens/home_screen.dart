import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  static const screenId = './home_screen';

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController _newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: RaisedButton(
//          onPressed: () {
//            signOut();
//            Navigator.of(context).pushNamedAndRemoveUntil(
//                LoginScreen.screenId, (route) => false);
//          },
//          child: Text('signout'),
//        ),
//      ),
      appBar: AppBar(
        title: Text('nikunj'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              _newGoogleMapController = controller;
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildChooseAddress(context),
          ),
        ],
      ),
    );
  }

  buildChooseAddress(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * 0.32,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              spreadRadius: 6,
              offset: Offset.zero),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi there',
            style: TextStyle(fontFamily: 'Brand-Regular'),
          ),
          Text(
            'Where to?',
            style: TextStyle(fontSize: 19, fontFamily: 'Brand-Regular'),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            height: mq.height * 0.04,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset.zero),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search),
                Text(
                  'Search Drop Off',
                  style: TextStyle(fontFamily: 'Brand Bold'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Icon(
                Icons.home,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Home',
                    style: TextStyle(fontSize: 17, fontFamily: 'Brand Bold'),
                  ),
                  Text(
                    'Your living home address',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Brand-Regular',
                        color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Divider(color: Colors.black26,),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Icon(
                Icons.work,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Work',
                    style: TextStyle(fontSize: 17, fontFamily: 'Brand Bold'),
                  ),
                  Text(
                    'Your office address',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Brand-Regular',
                        color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
