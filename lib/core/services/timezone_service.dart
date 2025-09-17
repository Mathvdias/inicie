import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class TimezoneService {
  Future<String> getLocalTimezone();
  Future<void> initializeTimeZones();
  tz.Location getLocation(String timezoneName);
  void setLocalLocation(tz.Location location);
}

class FlutterTimezoneService implements TimezoneService {
  @override
  Future<String> getLocalTimezone() async {
    return tz.TimeZone.UTC.abbreviation;
  }

  @override
  Future<void> initializeTimeZones() async {
    tz.initializeTimeZones();
  }

  @override
  tz.Location getLocation(String timezoneName) {
    return tz.getLocation(timezoneName);
  }

  @override
  void setLocalLocation(tz.Location location) {
    tz.setLocalLocation(location);
  }
}
