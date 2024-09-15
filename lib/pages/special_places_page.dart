import 'dart:convert';
import 'package:berlin_travel_app/models/event.dart';
import 'package:berlin_travel_app/pages/events_info_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpecialPlacesPage extends StatefulWidget {
  const SpecialPlacesPage({super.key});

  @override
  State<SpecialPlacesPage> createState() => _SpecialPlacesPageState();
}

class _SpecialPlacesPageState extends State<SpecialPlacesPage> {
  final List<Event> _specialEvents = [];

  bool _showFavorite = false;

  Widget _buildSpecialCard(Event eventData) {
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

  Future<void> _showPopup(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('All'),
              onPressed: () {
                setState(() {
                  _showFavorite = false;
                });
                Navigator.pop(context, 'All');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Favorite'),
              onPressed: () {
                setState(() {
                  _showFavorite = true;
                });
                Navigator.pop(context, 'Favorite');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
        );
      },
    );
  }

  void _loadData() async {
    final jsonString = await rootBundle.loadString("assets/data/events.json");
    final jsonData = jsonDecode(jsonString);
    for (var eventData in jsonData["events"]) {
      _specialEvents.add(Event.fromJson(eventData));
    }
    setState(() {});
  }

  List<Widget> _buildNewsCards() {
    final filteredNewsList = _showFavorite
        ? _specialEvents.where((event) => event.isFavorite).toList()
        : _specialEvents;

    return filteredNewsList.map((event) => _buildSpecialCard(event)).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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
        trailing: IconButton(
          onPressed: () async {
            await _showPopup(context);
          },
          icon: const Icon(
            CupertinoIcons.slider_horizontal_3,
            color: Colors.white,
          ),
          iconSize: 23,
        ),
        middle: const Text(
          "Special",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      child: _specialEvents.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: screenSize.height * 0.02),
              child: SingleChildScrollView(
                child: Column(
                  children: _buildNewsCards(),
                ),
              ),
            ),
    );
  }
}
