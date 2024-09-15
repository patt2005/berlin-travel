import 'package:berlin_travel_app/models/news.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:berlin_travel_app/utils/date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsInfoPage extends StatefulWidget {
  final News news;

  const NewsInfoPage({
    super.key,
    required this.news,
  });

  @override
  State<NewsInfoPage> createState() => _NewsInfoPageState();
}

class _NewsInfoPageState extends State<NewsInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        trailing: IconButton(
          onPressed: () {
            setState(() {
              widget.news.isFavorite = !widget.news.isFavorite;
            });
          },
          icon: Icon(
            widget.news.isFavorite
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart,
            color: Colors.red,
          ),
        ),
        middle: Text(
          widget.news.category,
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: widget.news.imageUrl,
                  width: screenSize.width,
                  height: screenSize.height * 0.2,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(color: Colors.white),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Text(
                widget.news.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenSize.height * 0.015),
              Text(
                formatDate(widget.news.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Text(
                widget.news.content,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
