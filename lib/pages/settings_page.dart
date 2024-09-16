import 'package:berlin_travel_app/pages/contact_us_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildSettingsButton(
      IconData icon, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: backgroundColor,
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.forward,
              color: backgroundColor,
              size: 19,
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
        border: const Border(
          bottom: BorderSide(
            color: Colors.white30,
          ),
        ),
        middle: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.02),
            _buildSettingsButton(
              CupertinoIcons.star,
              "Rate us",
              () async {
                final InAppReview inAppReview = InAppReview.instance;

                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildSettingsButton(
              CupertinoIcons.chat_bubble,
              "Contact us",
              () async {
                await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ContactUsPage(),
                  ),
                );
              },
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildSettingsButton(
              CupertinoIcons.share,
              "Share the app",
              () async {
                await Share.share('check out my app https://example.com',
                    subject: 'Look what I made!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
