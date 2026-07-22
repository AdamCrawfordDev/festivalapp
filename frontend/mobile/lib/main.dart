import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'features/auth/auth_controller.dart';
import 'routing/app_router.dart';
import 'screens/login_screen.dart';
import 'services/schedule_widget_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
   * Load the IANA timezone database before any schedule
   * dates are grouped or displayed.
   */
  tz.initializeTimeZones();

  await ScheduleWidgetService.configure();

  runApp(
    const ProviderScope(
      child: FestivalCompanionApp(),
    ),
  );
}

class FestivalCompanionApp
    extends ConsumerWidget {
  const FestivalCompanionApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authentication = ref.watch(
      authControllerProvider,
    );

    return authentication.when(
      loading: () {
        return MaterialApp(
          title: 'Festival Companion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (
        error,
        stackTrace,
      ) {
        return MaterialApp(
          title: 'Festival Companion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: const LoginScreen(),
        );
      },
      data: (authState) {
        if (!authState.isAuthenticated) {
          return MaterialApp(
            title: 'Festival Companion',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            home: const LoginScreen(),
          );
        }

        return MaterialApp.router(
          title: 'Festival Companion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        );
      },
    );
  }
}
