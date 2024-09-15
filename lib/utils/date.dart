import 'package:intl/intl.dart';

String formatDate(DateTime datetime) {
  String formattedDate = DateFormat('EEEE, MMMM d, y').format(datetime);
  return formattedDate;
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return '$hours hours and $minutes minutes';
}

DateTime getDateFromString(String date) {
  DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
  return parsedDate;
}
