import 'package:berlin_travel_app/models/event.dart';

class Trip {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Event> events;
  final String imageFilePath;
  final DateTime? reminder;

  Trip(
    this.reminder, {
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.events,
    required this.imageFilePath,
  });
}
