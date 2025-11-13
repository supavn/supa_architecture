import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supa_architecture/constants/constants.dart';

extension DateTimeComparison on DateTime {
  bool operator <(DateTime other) {
    return isBefore(other);
  }

  bool operator >(DateTime other) {
    return isAfter(other);
  }

  bool operator <=(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool operator >=(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  Duration operator -(DateTime other) {
    return difference(other);
  }

  DateTime getStartOfDay() {
    return DateTime(year, month, day);
  }

  DateTime getEndOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  String formatDurationTime() {
    DateTime now = DateTime.now();
    Duration duration = now.difference(this);

    // Check if the duration is less than an hour
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} phút trước';
    }

    // Check if the duration is less than a day (i.e., use hours)
    if (duration.inHours < 24) {
      return '${duration.inHours} giờ trước';
    }

    // Check if the started time was yesterday
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day) {
      return 'Hôm qua lúc ${_formatTimeOfDay(this)}';
    }

    // Default: Return the exact date and time if it's more than a day ago
    return '${_formatDate(this)} at ${_formatTimeOfDay(this)}';
  }

  // Helper function to format time of day in 12-hour format (e.g., 2:30 PM)
  String _formatTimeOfDay(DateTime time) {
    int hour =
        time.hour % 12 == 0 ? 12 : time.hour % 12; // Convert to 12-hour format
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Helper function to format date (e.g., Oct 12, 2024)
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  /// Formats the [DateTime] object into a string using the specified format.
  ///
  /// **Parameters:**
  /// - `dateFormat`: The format to use for the date. Defaults to [DateTimeFormatsVN.dateOnly].
  ///
  /// **Returns:**
  /// - A string representation of the [DateTime] object in the specified format.
  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    return DateFormat(dateFormat).format(toLocal());
  }

  bool get isOverdue {
    return isBefore(DateTime.now());
  }
}

extension TimeOfDayExtension on TimeOfDay {
  // Function to format TimeOfDay to HH:mm
  String formatTimeOfDay(BuildContext context) {
    final format = MaterialLocalizations.of(context).formatTimeOfDay(
      this,
      alwaysUse24HourFormat: true,
    );
    return format;
  }
}

extension DoubleTime on double {
  String toTimeString() {
    int hours = floor();
    double decimalMinutes = this - hours;
    int minutes = (decimalMinutes * 60).round();
    String timeString = "$hours:${minutes.toString().padLeft(2, '0')}";
    return timeString;
  }
}
