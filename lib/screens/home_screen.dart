import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/drawer.dart';
import '../provider/provider.dart';
import '../services/map_methods.dart';
import '../screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const screenId = './home_screen';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var bottomMapPadding = 0.0;

  final User user = FirebaseAuth.instance.currentUser;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController _newGoogleMapController;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    _newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    String address =
        await MapMethods.getAddressFromCoordinates(position, context);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: buildDrawer(context),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
                bottom: bottomMapPadding, top: mq.height * 0.06),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: HomeScreen._kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              _newGoogleMapController = controller;

              locatePosition();
              setState(() {
                bottomMapPadding = mq.height * 0.4;
              });
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
            child: buildBottomAddressBox(context, user),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: buildBottomFareEstimateBox()),
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
            const BoxShadow(
                color: Colors.black54,
                offset: const Offset(0.7, 0.7),
                blurRadius: 6,
                spreadRadius: 0.7)
          ],
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  buildBottomAddressBox(BuildContext context, User user) {
    String name = user.displayName;
    var firstName = name.split(' ');

    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * 0.4,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
              color: Colors.black38,
              blurRadius: 6,
              spreadRadius: 6,
              offset: Offset.zero),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi ${firstName[0]}!',
                style: const TextStyle(fontFamily: 'Brand-Regular'),
              ),
              const Text(
                'Where to?',
                style:
                    const TextStyle(fontSize: 19, fontFamily: 'Brand-Regular'),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (ctx) => SearchScreen()));
            },
            child: Container(
              height: mq.height * 0.05,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset.zero),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const Text(
                    'Search Drop Off',
                    style: const TextStyle(fontFamily: 'Brand Bold'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              const Icon(
                Icons.home,
                color: Colors.black45,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: mq.width * 0.8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        Provider.of<DataProvider>(context).pickUpLocation !=
                                null
                            ? Provider.of<DataProvider>(context)
                                .pickUpLocation
                                .placeName
                            : 'Add Home',
                        style: const TextStyle(
                            fontSize: 17, fontFamily: 'Brand Bold'),
                      ),
                    ),
                  ),
                  const Text(
                    'Your living home address',
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Regular',
                        color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          const Divider(
            color: Colors.black26,
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              const Icon(
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
                  const Text(
                    'Add Work',
                    style:
                        const TextStyle(fontSize: 17, fontFamily: 'Brand Bold'),
                  ),
                  const Text(
                    'Your office address',
                    style: const TextStyle(
                        fontSize: 14,
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

  buildBottomFareEstimateBox() {
    return Container();
  }
}
