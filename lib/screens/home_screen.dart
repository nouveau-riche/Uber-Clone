import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  static const screenId = './home_screen';

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController _newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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

      drawer: Drawer(
        child: buildDrawer(context),
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
            top: mq.height * 0.06,
            left: 20,
            child: buildDrawerIcon(),
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

  buildDrawerIcon() {
    return InkWell(
      onTap: () {
        _scaffoldKey.currentState.openDrawer();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(0.7, 0.7),
                blurRadius: 6,
                spreadRadius: 0.7)
          ],
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
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
              color: Colors.black38,
              blurRadius: 6,
              spreadRadius: 6,
              offset: Offset.zero),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
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
          Divider(
            color: Colors.black26,
          ),
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
