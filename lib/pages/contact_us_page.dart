import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

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
          "Settings",
          style: TextStyle(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.02),
            const Text(
              "Contact us",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            const Text(
              "Fill out the fields and we'll be sure to get back to you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            CupertinoTextField(
              placeholder: 'Name',
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            SizedBox(height: screenSize.height * 0.02),
            CupertinoTextField(
              placeholder: 'Surname',
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            SizedBox(height: screenSize.height * 0.02),
            CupertinoTextField(
              placeholder: 'Email',
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            SizedBox(height: screenSize.height * 0.02),
            CupertinoTextField(
              placeholder: 'Message',
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Send",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
          ],
        ),
      ),
    );
  }
}
