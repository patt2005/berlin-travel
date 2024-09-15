import 'package:berlin_travel_app/api/weather_api.dart';
import 'package:berlin_travel_app/pages/onboarding_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await WeatherApi.getWeatherData();
    await Future.delayed(
      const Duration(seconds: 3),
      () async {
        await Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.1,
              width: screenSize.width,
            ),
            const Text(
              "Berlin",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "BalooChettan",
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            const Text(
              "Travel",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "BalooChettan",
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: screenSize.height * 0.06),
            Image.asset(
              "assets/images/splash_image.png",
              height: screenSize.height * 0.25,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenSize.height * 0.06),
            const CupertinoActivityIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
