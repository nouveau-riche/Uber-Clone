import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place_predication.dart';
import '../services/config_map.dart';
import '../provider/provider.dart';
import '../services/http_request.dart';
import '../widgets/predication_list_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _pickUpLocationController = TextEditingController();
  TextEditingController _dropOffLocationController = TextEditingController();

  List<PlacePredication> predictionsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<DataProvider>(context).pickUpLocation.placeName ?? '';
    _pickUpLocationController.text = placeAddress;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Set Drop Off',
          style: TextStyle(color: Colors.black, fontFamily: 'Brand-Regular'),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          buildTopContainer(context),
          if (predictionsList.length > 0) buildPredicationPlacesList(),
        ],
      ),
    );
  }

  Widget buildTopContainer(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
            blurRadius: 1,
            spreadRadius: 2,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        children: [
          buildPickUpField(mq.width * 0.85),
          const SizedBox(
            height: 8,
          ),
          buildDropOffLocation(mq.width * 0.85),
          SizedBox(
            height: mq.height * 0.032,
          ),
          //buildPredicationList(),
        ],
      ),
    );
  }

  Widget buildPickUpField(double width) {
    return Row(
      children: [
        Container(
            height: 30,
            width: 20,
            child: Image.asset('assets/images/pickicon.png')),
        SizedBox(
          width: 7,
        ),
        Container(
          height: 36,
          width: width,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          child: TextField(
            cursorColor: Colors.black87,
            decoration: InputDecoration(
              hintText: 'PickUp Location',
              hintStyle: TextStyle(fontFamily: 'Brand-Regular'),
              isDense: true,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 6, top: 8, bottom: 2, right: 2),
            ),
            controller: _pickUpLocationController,
          ),
        ),
      ],
    );
  }

  Widget buildDropOffLocation(double width) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 20,
          child: Image.asset('assets/images/desticon.png'),
        ),
        const SizedBox(
          width: 7,
        ),
        Container(
          height: 36,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.grey[300],
          ),
          child: TextField(
            onChanged: (value) {
              findPlace(value);
            },
            cursorColor: Colors.black87,
            decoration: InputDecoration(
              hintText: 'Where to?',
              hintStyle: TextStyle(fontFamily: 'Brand-Regular'),
              isDense: true,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 6, top: 8, bottom: 2, right: 2),
            ),
            controller: _dropOffLocationController,
          ),
        ),
      ],
    );
  }

  Widget buildPredicationPlacesList() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (ctx, index) {
          return PredicationListTile(predictionsList[index]);
        },
        separatorBuilder: (ctx, index) => Divider(),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: predictionsList.length,
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in';

      var res = await HttpMethods.getRequest(autoCompleteUrl);

      if (res == 'failed') {
        return;
      }

      if (res['status'] == 'OK') {
        predictionsList = [];
        setState(() {});

        var predications = res['predictions'];

        predications.forEach((doc) {
          predictionsList.add(
            PlacePredication(
                placeId: doc['place_id'],
                mainText: doc['structured_formatting']['main_text'],
                secondaryText: doc['structured_formatting']['secondary_text']),
          );
        });

        setState(() {});
      }
    }
  }
}
