import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/festival_list_screen.dart';
import '../screens/festival_screen.dart';
import '../screens/my_schedule_screen.dart';

final GlobalKey<NavigatorState>
    _rootNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState>
    _festivalsNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState>
    _scheduleNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/festivals',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
        context,
        state,
        navigationShell,
      ) {
        return AppScaffold(
          navigationShell:
              navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey:
              _festivalsNavigatorKey,
          routes: [
            GoRoute(
              path: '/festivals',
              builder: (
                context,
                state,
              ) {
                return const FestivalListScreen();
              },
              routes: [
                GoRoute(
                  path: ':festivalId',
                  builder: (
                    context,
                    state,
                  ) {
                    final festivalId =
                        int.tryParse(
                              state.pathParameters[
                                  'festivalId'] ??
                                  '',
                            ) ??
                            0;

                    final scrollToSchedule =
                        state.uri.queryParameters[
                              'section'
                            ] ==
                            'schedule';

                    return FestivalScreen(
                      festivalId:
                          festivalId,
                      scrollToSchedule:
                          scrollToSchedule,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              _scheduleNavigatorKey,
          routes: [
            GoRoute(
              path: '/schedule',
              builder: (
                context,
                state,
              ) {
                return const MyScheduleScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppScaffold
    extends StatelessWidget {
  const AppScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell
      navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
    );
  }
}