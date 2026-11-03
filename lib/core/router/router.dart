import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/core/navigation/app_shell.dart';
import 'package:b_risk/features/auth/presentation/auth_screen.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/auth/presentation/verify_email_screen.dart';
import 'package:b_risk/features/dashboard/presentation/dashboard_screen.dart';
import 'package:b_risk/features/map/presentation/map_screen.dart';
import 'package:b_risk/features/alerts/presentation/alerts_screen.dart';
import 'package:b_risk/features/messages/presentation/messages_screen.dart';
import 'package:b_risk/features/reports/presentation/reports_screen.dart';

part 'router.g.dart';

// Global keys for navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _shellNavigatorMapKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final _shellNavigatorAlertsKey = GlobalKey<NavigatorState>(debugLabel: 'alerts');
final _shellNavigatorReportsKey = GlobalKey<NavigatorState>(debugLabel: 'reports');
final _shellNavigatorMessagesKey = GlobalKey<NavigatorState>(debugLabel: 'messages');

/// `unknown` while Firebase is still restoring the session.
enum AuthStatus { unknown, signedOut, unverified, verified }

/// Signed-out users only see /login, unverified ones only /verify.
String? authRedirect(AuthStatus status, String location) {
  return switch (status) {
    AuthStatus.unknown => null,
    AuthStatus.signedOut => location == '/login' ? null : '/login',
    AuthStatus.unverified => location == '/verify' ? null : '/verify',
    AuthStatus.verified => location == '/login' || location == '/verify' ? '/dashboard' : null,
  };
}

@riverpod
GoRouter goRouter(Ref ref) {
  final status = ValueNotifier(AuthStatus.unknown);
  ref.listen(
    authSessionProvider,
    (_, session) => status.value = switch (session) {
      AsyncLoading() => AuthStatus.unknown,
      AsyncData(value: final s?) => s.emailVerified ? AuthStatus.verified : AuthStatus.unverified,
      _ => AuthStatus.signedOut,
    },
    fireImmediately: true,
  );
  ref.onDispose(status.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: status,
    redirect: (context, state) => authRedirect(status.value, state.matchedLocation),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
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
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReportsKey,
            routes: [
              GoRoute(
                path: '/reports',
                name: 'reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMessagesKey,
            routes: [
              GoRoute(
                path: '/messages',
                name: 'messages',
                builder: (context, state) => const MessagesScreen(),
                routes: [
                  // An admin's view of one resident's conversation
                  GoRoute(
                    path: ':uid',
                    builder: (context, state) => ChatScreen(threadUid: state.pathParameters['uid']!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
