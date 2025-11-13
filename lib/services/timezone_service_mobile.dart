import 'package:flutter_timezone/flutter_timezone.dart';

Future<String> getLocalTimezone() async {
  return (await FlutterTimezone.getLocalTimezone()).identifier;
}
