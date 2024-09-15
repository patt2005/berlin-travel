import 'package:berlin_travel_app/pages/navigation_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<String> _titles = [
    "News and interesting events in Berlin",
    "Events in Berlin",
    "Create your trip",
  ];
  final List<String> _descriptions = [
    "Discover the city, its unique neighborhoods, historic sites and top establishments.",
    "Find out about all important cultural events: concerts, festivals, exhibitions - always be one step ahead.",
    "Plan your own unique itinerary. Add points of interest, save your favorites and share your plans with friends.",
  ];
  final List<String> _imagePaths = [
    "assets/images/onboarding/image1.png",
    "assets/images/onboarding/image2.png",
    "assets/images/onboarding/image3.png",
  ];

  int _currentPageIndex = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            for (int i = 0; i < _titles.length; i++)
              Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    Image.asset(
                      _imagePaths[i],
                      width: screenSize.width,
                      height: screenSize.height * 0.425,
                      fit: BoxFit.scaleDown,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.05),
                          Text(
                            _titles[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.025),
                          Text(
                            _descriptions[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int j = 0; j < 3; j++)
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: i == j ? 45 : 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color:
                                        i == j ? secondaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 10),
                                ),
                                backgroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                _currentPageIndex = 2;
                                await _pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 10),
                                ),
                                backgroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_currentPageIndex == 2) {
                                  await Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const NavigationPage(),
                                    ),
                                  );
                                } else {
                                  _currentPageIndex++;
                                  await _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                ),
                              ),
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
