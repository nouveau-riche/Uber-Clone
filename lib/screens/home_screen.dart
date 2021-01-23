import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uberrider/models/direction_detail.dart';
import 'package:uberrider/widgets/progressDialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var bottomMapPadding = 0.0;
  final User user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailContainerHeight = 0;
  double searchContainerHeight = 300;

  DirectionDetail tripDirectionDetails;

  bool openDrawer = true;

  void displayRideDetailContainer() async {
    await getPlaceDirection();

    setState(() {
      rideDetailContainerHeight = 300;
      searchContainerHeight = 0;
      openDrawer = false;
    });
  }

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

  resetApp() {
    setState(() {
      rideDetailContainerHeight = 0;
      searchContainerHeight = 300;
      openDrawer = true;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();

      polyLineCoordinates.clear();
    });

    locatePosition();
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<DataProvider>(context, listen: false).pickUpLocation;
    var finalPos =
        Provider.of<DataProvider>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context, builder: (ctx) => ProgressDialog('Please wait...'));

    var details =
        await MapMethods.getPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    Navigator.of(context).pop();

    setState(() {
      tripDirectionDetails = details;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodePoints);

    polyLineCoordinates.clear();

    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polylineID'),
        color: Colors.pink,
        points: polyLineCoordinates,
        jointType: JointType.round,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

//    LatLngBounds latLngBounds;
//    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
//        pickUpLatLng.longitude > dropOffLatLng.longitude) {
//      latLngBounds =
//          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
//    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
//      latLngBounds = LatLngBounds(
//          southwest: LatLng(dropOffLatLng.latitude, dropOffLatLng.longitude),
//          northeast: LatLng(pickUpLatLng.latitude, pickUpLatLng.longitude));
//    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
//      latLngBounds = LatLngBounds(
//          southwest: LatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
//          northeast: LatLng(dropOffLatLng.latitude, dropOffLatLng.longitude));
//    } else {
//      latLngBounds =
//          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
//    }

//    _newGoogleMapController
//        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      markerId: MarkerId('MarkerId'),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: 'My Location'),
      position: pickUpLatLng,
    );

    Marker dropOffLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: MarkerId('dropOffId'),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: 'DropOff Location'),
      position: dropOffLatLng,
    );

    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });

    Circle pickUpCircle = Circle(
        fillColor: Colors.yellow,
        center: pickUpLatLng,
        radius: 12,
        strokeColor: Colors.yellowAccent,
        strokeWidth: 4,
        circleId: CircleId('circleId'));

    Circle dropOffCircle = Circle(
        fillColor: Colors.blue,
        center: dropOffLatLng,
        radius: 12,
        strokeColor: Colors.blueAccent,
        strokeWidth: 4,
        circleId: CircleId('dropOffId'));

    setState(() {
      circlesSet.add(pickUpCircle);
      circlesSet.add(dropOffCircle);
    });
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
            markers: markersSet,
            circles: circlesSet,
            polylines: polylineSet,
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
            child: buildBottomFareEstimateBox(context),
          ),
        ],
      ),
    );
  }

  buildDrawerIcon() {
    return InkWell(
      onTap: () {
        if (openDrawer) {
          _scaffoldKey.currentState.openDrawer();
        } else {
          resetApp();
        }
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
          child: Icon(
            openDrawer == true ? Icons.menu : Icons.clear,
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
    return AnimatedSize(
      vsync: this,
      curve: Curves.bounceIn,
      duration: Duration(microseconds: 160),
      child: Container(
        //height: mq.height * 0.4,
        height: searchContainerHeight,
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
                  style: const TextStyle(
                      fontSize: 19, fontFamily: 'Brand-Regular'),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (ctx) => SearchScreen()));

                if (res == 'obtainedDirection') {
                  displayRideDetailContainer();
                }
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
                      style: const TextStyle(
                          fontSize: 17, fontFamily: 'Brand Bold'),
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
      ),
    );
  }

  buildBottomFareEstimateBox(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return AnimatedSize(
      vsync: this,
      curve: Curves.bounceIn,
      duration: Duration(microseconds: 160),
      child: Container(
        //height: mq.height * 0.4,
        height: rideDetailContainerHeight,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                spreadRadius: 0.5,
                offset: Offset.zero),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/taxi.png',
                          height: 70,
                          width: 80,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Car',
                              style: TextStyle(fontFamily: 'Brand Bold'),
                            ),
                            Text(
                              tripDirectionDetails != null
                                  ? tripDirectionDetails.distanceText
                                  : '',
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: 'Brand Bold'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        tripDirectionDetails != null
                            ? '${MapMethods.calculateFares(tripDirectionDetails)} Rs'
                            : '',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand Bold'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(CupertinoIcons.money_dollar),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Cash'),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Request',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Brand Bold'),
                    ),
                    Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
