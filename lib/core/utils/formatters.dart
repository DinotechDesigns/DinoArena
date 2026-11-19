import 'package:intl/intl.dart';

abstract final class Fmt {
  static final NumberFormat _inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static String money(num value) => _inr.format(value);
  static String time(DateTime d) => DateFormat('h:mm a').format(d);
  static String hour(DateTime d) => DateFormat(d.minute == 0 ? 'h a' : 'h:mm a').format(d);
  static String timeRange(DateTime a, DateTime b) => '${time(a)} – ${time(b)}';
  static String dayShort(DateTime d) => DateFormat('EEE').format(d);
  static String dayNum(DateTime d) => DateFormat('d').format(d);
  static String date(DateTime d) => DateFormat('EEE, d MMM').format(d);
  static String dateLong(DateTime d) => DateFormat('EEEE, d MMMM yyyy').format(d);
  static String monthYear(DateTime d) => DateFormat('MMMM yyyy').format(d);
  static String dateShort(DateTime d) => DateFormat('d MMM').format(d);

  static String relative(DateTime d, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return dateShort(d);
  }

  static String greeting([DateTime? now]) {
    final h = (now ?? DateTime.now()).hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

extension DateOnly on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  bool isSameDay(DateTime o) => year == o.year && month == o.month && day == o.day;
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;
}
