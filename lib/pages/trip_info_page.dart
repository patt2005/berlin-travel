import 'dart:io';
import 'package:berlin_travel_app/models/event.dart';
import 'package:berlin_travel_app/models/trip.dart';
import 'package:berlin_travel_app/pages/events_info_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:berlin_travel_app/utils/date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TripInfoPage extends StatelessWidget {
  final List<Trip> tripList;
  final int tripIndex;

  const TripInfoPage({
    super.key,
    required this.tripList,
    required this.tripIndex,
  });

  Widget _buildSpecialCard(Event eventData, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => EventsInfoPage(event: eventData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: eventData.imageUrl,
                width: screenSize.width,
                height: screenSize.height * 0.2,
                placeholder: (context, url) => const Center(
                  child: CupertinoActivityIndicator(color: Colors.white),
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              left: 5,
              child: Text(
                eventData.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        backgroundColor: backgroundColor,
        middle: Text(
          tripList[tripIndex].name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.02),
            Container(
              width: screenSize.width,
              height: screenSize.height * 0.225,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                      File(tripList[tripIndex].imageFilePath),
                    ),
                    fit: BoxFit.cover),
              ),
              margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Travel dates: ${formatDate(tripList[tripIndex].startDate)} - ${formatDate(tripList[tripIndex].endDate)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      startRangeSelectionColor: Colors.red,
                      initialSelectedRange: PickerDateRange(
                          tripList[tripIndex].startDate,
                          tripList[tripIndex].endDate),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  for (int i = 0; i < tripList[tripIndex].events.length; i++)
                    _buildSpecialCard(tripList[tripIndex].events[i], context),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      tripList.remove(tripList[tripIndex]);
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Delete trip",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
