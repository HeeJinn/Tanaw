import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/core/navigation/app_shell.dart';
import 'package:b_risk/features/dashboard/presentation/dashboard_screen.dart';
import 'package:b_risk/features/map/presentation/map_screen.dart';
import 'package:b_risk/features/alerts/presentation/alerts_screen.dart';

part 'router.g.dart';

// Global keys for navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _shellNavigatorMapKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final _shellNavigatorAlertsKey = GlobalKey<NavigatorState>(debugLabel: 'alerts');

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // ── Branch 0: Dashboard ──
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // ── Branch 1: Risk Map ──
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMapKey,
            routes: [
              GoRoute(
                path: '/map',
                name: 'map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),

          // ── Branch 2: Alerts ──
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAlertsKey,
            routes: [
              GoRoute(
                path: '/alerts',
                name: 'alerts',
                builder: (context, state) => const AlertsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
