import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  final dateTime = DateTime.parse(dateStr);
  final formatter = DateFormat('EEE, dd MMM yyyy HH:mm \'GMT\'');
  return formatter.format(dateTime.toUtc());
}
