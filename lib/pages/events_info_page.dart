import 'package:berlin_travel_app/models/event.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:berlin_travel_app/utils/date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventsInfoPage extends StatefulWidget {
  final Event event;

  const EventsInfoPage({
    super.key,
    required this.event,
  });

  @override
  State<EventsInfoPage> createState() => _EventsInfoPageState();
}

class _EventsInfoPageState extends State<EventsInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: IconButton(
          onPressed: () {
            setState(() {
              widget.event.isFavorite = !widget.event.isFavorite;
            });
          },
          icon: Icon(
            widget.event.isFavorite
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart,
            color: Colors.red,
          ),
        ),
        middle: Text(
          widget.event.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            child: CachedNetworkImage(
              imageUrl: widget.event.imageUrl,
              width: screenSize.width,
              height: screenSize.height * 0.24,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: screenSize.width,
              height: screenSize.height * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/location.png",
                        width: 30,
                        height: 30,
                      ),
                      const Text(
                        "Germany, Berlin",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        color: Colors.orange,
                        size: 22,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        widget.event.rating.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "(${widget.event.reviews})",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Duration: ${formatDuration(Duration(minutes: widget.event.duration))}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price per adult: £${widget.event.price}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
