import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/timezone_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late FlutterTimezoneService timezoneService;

  setUp(() async {
    tz.initializeTimeZones();
    timezoneService = FlutterTimezoneService();
  });

  group('FlutterTimezoneService', () {
    test('initializeTimeZones should complete successfully', () async {
      final service = FlutterTimezoneService();
      await expectLater(service.initializeTimeZones(), completes);
    });

    test('getLocation returns a tz.Location for a given timezone name', () {
      final location = timezoneService.getLocation('America/New_York');
      expect(location, isA<tz.Location>());
      expect(location.name, 'America/New_York');
    });

    test('setLocalLocation sets the local timezone', () {
      final location = tz.getLocation('America/New_York');
      timezoneService.setLocalLocation(location);
      expect(tz.local, location);
    });

    test(
      'getLocalTimezone returns a string with the timezone abbreviation',
      () async {
        final abbreviation = await timezoneService.getLocalTimezone();
        expect(abbreviation, isA<String>());
        // O teste original retorna 'UTC', então esperamos 'UTC'
        expect(abbreviation, 'UTC');
      },
    );
  });
}
