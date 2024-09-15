import 'dart:convert';
import 'dart:io';
import 'package:berlin_travel_app/models/event.dart';
import 'package:berlin_travel_app/models/trip.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:berlin_travel_app/utils/date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:path/path.dart' as path;

class AddTripPage extends StatefulWidget {
  final List<Trip> tripList;

  const AddTripPage({
    super.key,
    required this.tripList,
  });

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController _titleController = TextEditingController();

  final List<Event> _specialEvents = [];
  final List<Event> _selectedEvents = [];

  final PageController _pageController = PageController();

  File? _imageFile;

  String _range = '';

  DateTime? _reminderDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    }
    setState(() {});
  }

  Widget _buildSpecialCard(Event eventData, bool showSelectButton) {
    return Container(
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
          if (showSelectButton)
            Positioned(
              top: 5,
              right: 5,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () async {
                  setState(() {
                    _selectedEvents.add(eventData);
                  });
                  await _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text(
                  "Select",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
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

  Future<void> _showPopup(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take a photo'),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  final cacheDir = await getTemporaryDirectory();
                  final filePath =
                      path.join(cacheDir.path, 'profile_picture.png');
                  final savedImage = await File(image.path).copy(filePath);
                  setState(() {
                    _imageFile = savedImage;
                  });
                }
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Select from gallery'),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final cacheDir = await getTemporaryDirectory();
                  final filePath =
                      path.join(cacheDir.path, 'profile_picture.png');
                  final savedImage = await File(image.path).copy(filePath);
                  setState(() {
                    _imageFile = savedImage;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: DateTime.now(),
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _reminderDate = newDateTime;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        border: const Border(
          bottom: BorderSide(
            color: Colors.white30,
          ),
        ),
        middle: const Text(
          "Create travel",
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
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Create travel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Let's come up with a name for your trip.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  CupertinoTextField(
                    onChanged: (value) {
                      setState(() {
                        _titleController.text = value;
                      });
                    },
                    controller: _titleController,
                    placeholder: 'For example, Road to Berlin',
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
                      backgroundColor: WidgetStatePropertyAll(
                          _titleController.text.isEmpty
                              ? Colors.white38
                              : Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015),
                      ),
                    ),
                    onPressed: () async {
                      if (_titleController.text.isNotEmpty) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Select a travel\ninterval",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Select the start and end date of the trip.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    _range,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      onSelectionChanged: _onSelectionChanged,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          _range.isEmpty ? Colors.white38 : Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015),
                      ),
                    ),
                    onPressed: () async {
                      if (_range.isNotEmpty) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
          for (int i = 0; i < _range.split("-").length; i++)
            SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.02),
                      const Text(
                        "Select the events you want to attend",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        _range.split("-")[i].trim(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      for (int i = 0; i < _specialEvents.length; i++)
                        _buildSpecialCard(_specialEvents[i], true)
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.02),
                    const Text(
                      "Check the trip plan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      _range.split("-").first.trim(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    if (_range.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          startRangeSelectionColor: Colors.red,
                          initialSelectedRange: PickerDateRange(
                            getDateFromString(_range.split("-").first.trim()),
                            getDateFromString(_range.split("-").last.trim()),
                          ),
                        ),
                      ),
                    SizedBox(height: screenSize.height * 0.02),
                    if (_selectedEvents.isNotEmpty)
                      _buildSpecialCard(_selectedEvents.first, false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue),
                          ),
                          onPressed: () async {
                            await _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.02),
                    const Text(
                      "Check the trip plan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      _range.split("-").last.trim(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    if (_range.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          endRangeSelectionColor: Colors.red,
                          initialSelectedRange: PickerDateRange(
                            getDateFromString(_range.split("-").first.trim()),
                            getDateFromString(_range.split("-").last.trim()),
                          ),
                        ),
                      ),
                    SizedBox(height: screenSize.height * 0.02),
                    if (_selectedEvents.isNotEmpty)
                      _buildSpecialCard(_selectedEvents.last, false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue),
                          ),
                          onPressed: () async {
                            await _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenSize.width,
            width: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Choose a cover\nimage for the trip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                  if (_imageFile == null)
                    GestureDetector(
                      onTap: () async {
                        await _showPopup(context);
                      },
                      child: Container(
                        width: screenSize.width,
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.035),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/image_pick.png",
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                  if (_imageFile != null)
                    Container(
                      width: screenSize.width,
                      padding: EdgeInsets.zero,
                      height: screenSize.height * 0.225,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          _imageFile == null ? Colors.white38 : Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015),
                      ),
                    ),
                    onPressed: () async {
                      if (_imageFile != null) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    "Set a reminder date",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  if (_reminderDate != null)
                    Text(
                      formatDate(_reminderDate!),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  SizedBox(height: screenSize.height * 0.06),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: const Text(
                      "Pick",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _showDateTimePicker(context);
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          _imageFile == null ? Colors.white38 : Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015),
                      ),
                    ),
                    onPressed: () {
                      widget.tripList.add(
                        Trip(
                          null,
                          endDate:
                              getDateFromString(_range.split("-").last.trim()),
                          startDate:
                              getDateFromString(_range.split("-").first.trim()),
                          name: _titleController.text,
                          events: _selectedEvents,
                          imageFilePath: _imageFile!.path,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Do not set a reminder",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          _imageFile == null ? Colors.white38 : Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015),
                      ),
                    ),
                    onPressed: () {
                      if (_reminderDate != null) {
                        widget.tripList.add(
                          Trip(
                            _reminderDate,
                            endDate: getDateFromString(
                                _range.split("-").last.trim()),
                            startDate: getDateFromString(
                                _range.split("-").first.trim()),
                            name: _titleController.text,
                            events: _selectedEvents,
                            imageFilePath: _imageFile!.path,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
