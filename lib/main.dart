import 'package:flutter/material.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart' show StorageService;
import 'package:inicie/core/theme/app_theme.dart';
import 'package:inicie/features/tasks/presentation/views/task_list_page.dart';
import 'package:inicie/l10n/app_localizations.dart' show AppLocalizations;
import 'package:timezone/data/latest.dart' as tz;

import 'package:inicie/utils/app_logger.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i("main: WidgetsFlutterBinding ensured.");

  setupLocator();
  logger.i("main: Service locator setup complete.");

  tz.initializeTimeZones();
  logger.i("main: Timezones initialized.");

  await getIt<StorageService>().init();
  logger.i("main: StorageService initialized.");

  await getIt<NotificationService>().init();
  logger.i("main: NotificationService initialized.");
}

void main() async {
  await initializeApp();
  runApp(const InicieApp());
}

class InicieApp extends StatelessWidget {
  const InicieApp({super.key});

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
