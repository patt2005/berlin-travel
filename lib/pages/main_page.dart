import 'dart:convert';
import 'package:berlin_travel_app/models/news.dart';
import 'package:berlin_travel_app/pages/news_info_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> imgList = [
    'assets/images/carousel/image1.png',
    'assets/images/carousel/image2.png',
    'assets/images/carousel/image3.png',
    'assets/images/carousel/image4.png',
  ];

  int _current = 0;

  final List<News> _newsList = [];

  bool _showFavorite = false;

  Widget _buildWeatherCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: screenSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFA7A7A7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Time in\nBerlin: $berlinTime",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 28,
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/weather_icon.png",
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    "Weather now: ${temperature.round()}°C",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(13),
              child: AnalogClock(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: imgList
              .map(
                (item) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.3,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 15,
              height: 15,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                color: _current == index ? Colors.white : Colors.transparent,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNewsCard(News news) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => NewsInfoPage(news: news),
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
                imageUrl: news.imageUrl,
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
                news.title,
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

  List<Widget> _buildNewsCards() {
    final filteredNewsList = _showFavorite
        ? _newsList.where((news) => news.isFavorite).toList()
        : _newsList;

    return filteredNewsList.map((news) => _buildNewsCard(news)).toList();
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

  void _initialize() async {
    final jsonString = await rootBundle.loadString("assets/data/news.json");
    final data = jsonDecode(jsonString);
    for (var newsData in data["news"]) {
      _newsList.add(News.fromJson(newsData));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
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
          "Main",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      child: _newsList.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  _buildWeatherCard(),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildCarousel(),
                  SizedBox(height: screenSize.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _buildNewsCards(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
