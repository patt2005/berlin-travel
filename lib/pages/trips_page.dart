import 'dart:io';
import 'package:berlin_travel_app/models/trip.dart';
import 'package:berlin_travel_app/pages/add_trip_page.dart';
import 'package:berlin_travel_app/pages/trip_info_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final List<Trip> _tripList = [];

  Widget _buildAddTripCard() {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => AddTripPage(tripList: _tripList),
          ),
        );
        setState(() {});
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.04),
            width: screenSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.black],
              ),
            ),
            child: Icon(
              CupertinoIcons.add,
              color: backgroundColor,
              size: 45,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: Text(
              _tripList.isEmpty
                  ? "No trips yet? Let's create the first one."
                  : "Create a new journey",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTripCard(int index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TripInfoPage(
              tripList: _tripList,
              tripIndex: index,
            ),
          ),
        );
      },
      child: Container(
        width: screenSize.width,
        height: screenSize.height * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: FileImage(
                File(_tripList[index].imageFilePath),
              ),
              fit: BoxFit.cover),
        ),
        margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              right: 5,
              left: 5,
              child: Text(
                _tripList[index].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: const Border(
          bottom: BorderSide(
            color: Colors.white30,
          ),
        ),
        middle: const Text(
          "My travels",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.02),
              for (int i = 0; i < _tripList.length; i++) _buildTripCard(i),
              _buildAddTripCard(),
            ],
          ),
        ),
      ),
    );
  }
}
