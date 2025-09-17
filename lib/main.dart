import 'package:flutter/material.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart' show StorageService;
import 'package:inicie/core/theme/app_theme.dart';
import 'package:inicie/features/tasks/presentation/views/task_list_page.dart';
import 'package:inicie/l10n/app_localizations.dart' show AppLocalizations;
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the service locator
  setupLocator();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize storage service
  await getIt<StorageService>().init();

  // Initialize the notification service
  await getIt<NotificationService>().init();

  getIt.registerSingleton<ValueNotifier<Locale>>(
    ValueNotifier<Locale>(const Locale('en')),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: getIt<ValueNotifier<Locale>>(),
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'Inicie Tasks',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TaskListPage(),
        );
      },
    );
  }
}
