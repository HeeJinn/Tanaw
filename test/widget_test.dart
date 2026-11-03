import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';

import 'package:b_risk/core/router/router.dart';
import 'package:b_risk/core/theme/app_theme.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/domain/repositories/alert_repository.dart';
import 'package:b_risk/features/alerts/presentation/alerts_screen.dart';
import 'package:b_risk/features/alerts/presentation/providers/alert_providers.dart';
import 'package:b_risk/features/alerts/presentation/widgets/alert_card.dart';
import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/auth/domain/repositories/auth_repository.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/auth/presentation/verify_email_screen.dart';
import 'package:b_risk/features/dashboard/presentation/dashboard_screen.dart';
import 'package:b_risk/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:b_risk/features/map/data/models/barangay_model.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/domain/repositories/barangay_repository.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/temperature_line_chart.dart';
import 'package:b_risk/features/messages/domain/entities/chat.dart';
import 'package:b_risk/features/messages/domain/repositories/chat_repository.dart';
import 'package:b_risk/features/messages/presentation/messages_screen.dart';
import 'package:b_risk/features/messages/presentation/providers/chat_providers.dart';
import 'package:b_risk/features/reports/domain/entities/report.dart';
import 'package:b_risk/features/reports/domain/repositories/report_repository.dart';
import 'package:b_risk/features/reports/presentation/providers/report_providers.dart';
import 'package:b_risk/features/reports/presentation/reports_screen.dart';

// Same files tool/seed/seed.mjs uploads to Firestore.
List<Map<String, dynamic>> _seed(String name) =>
    (jsonDecode(File('tool/seed/$name.json').readAsStringSync()) as List).cast();

final seedBarangays = _seed('barangays').map(BarangayModel.fromJson).toList();
final seedAlerts = [
  for (final a in _seed('alerts'))
    Alert(
      id: a['id'],
      title: a['title'],
      description: a['description'],
      severity: a['severity'],
      type: a['type'],
      barangayName: a['barangayName'],
      timestamp: DateTime.now().subtract(Duration(minutes: a['minutesAgo'])),
    ),
];

const ana = AppUser(uid: 'ana', name: 'Ana Cruz', email: 'ana@x.ph', phone: '09171234567');
const staff = AppUser(uid: 'staff', name: 'MDRRMO Staff', email: 'staff@x.ph', role: 'admin');

class FakeBarangayRepository implements BarangayRepository {
  @override
  Stream<List<Barangay>> watchBarangays() => Stream.value(seedBarangays);
}

class FakeAlertRepository implements AlertRepository {
  Set<String> saved = {};

  @override
  Stream<List<Alert>> watchAlerts() => Stream.value(seedAlerts);

  @override
  Future<Set<String>> getReadIds() async => saved;

  @override
  Future<void> saveReadIds(Set<String> ids) async => saved = ids;
}

class FakeAuthRepository implements AuthRepository {
  final AppUser user;
  final bool verified;
  int verificationEmails = 0;

  FakeAuthRepository(this.user, {this.verified = true});

  @override
  Stream<AuthSession?> watchSession() =>
      Stream.value((uid: user.uid, email: user.email, emailVerified: verified));

  @override
  Future<void> sendEmailVerification() async => verificationEmails++;

  @override
  Future<bool> refreshEmailVerified() async => verified;

  @override
  Stream<AppUser> watchProfile(String uid) => Stream.value(user);

  @override
  Future<void> signIn({required String email, required String password}) async {}

  @override
  Future<void> register({required String name, required String phone, required String email, required String password}) async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {}
}

class FakeReportRepository implements ReportRepository {
  final submitted = <Map<String, String>>[];
  final mine = Report(
    id: 'r1',
    reporterUid: 'ana',
    reporterName: 'Ana Cruz',
    type: 'flood',
    barangayName: 'Bued',
    details: 'Water rising near the bridge',
    status: 'pending',
    createdAt: DateTime.now(),
  );
  final others = Report(
    id: 'r2',
    reporterUid: 'ben',
    reporterName: 'Ben Reyes',
    type: 'heat',
    barangayName: 'Capas',
    details: 'Very hot at the market',
    status: 'reviewing',
    createdAt: DateTime.now(),
  );

  @override
  Future<void> submit({required AppUser reporter, required String type, required String barangayName, required String details}) async {
    submitted.add({'uid': reporter.uid, 'type': type, 'barangay': barangayName, 'details': details});
  }

  @override
  Stream<List<Report>> watchMine(String uid) => Stream.value([mine]);

  @override
  Stream<List<Report>> watchAll() => Stream.value([mine, others]);

  @override
  Future<void> setStatus(String id, String status) async {}
}

class FakeChatRepository implements ChatRepository {
  final sent = <String>[];

  @override
  Stream<List<ChatMessage>> watchMessages(String threadUid) => Stream.value([
        ChatMessage(id: 'm1', text: 'Is the road to Bued passable?', senderUid: 'ana', fromAdmin: false, createdAt: DateTime.now()),
        ChatMessage(id: 'm2', text: 'Not yet, use the highway.', senderUid: 'staff', fromAdmin: true, createdAt: DateTime.now()),
      ]);

  @override
  Stream<List<ChatThread>> watchThreads() => Stream.value([
        ChatThread(uid: 'ana', userName: 'Ana Cruz', lastMessage: 'Not yet, use the highway.', updatedAt: DateTime.now()),
      ]);

  @override
  Stream<ChatThread?> watchThread(String threadUid) => Stream.value(null);

  @override
  Future<void> send({required String threadUid, required AppUser sender, required String text}) async => sent.add(text);
}

void main() {
  late FakeAlertRepository alertRepo;
  late FakeReportRepository reportRepo;
  late FakeChatRepository chatRepo;
  late ProviderContainer container;

  List overridesFor(AppUser user) => [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(user)),
        barangayRepositoryProvider.overrideWithValue(FakeBarangayRepository()),
        alertRepositoryProvider.overrideWith((ref) => alertRepo),
        reportRepositoryProvider.overrideWith((ref) => reportRepo),
        chatRepositoryProvider.overrideWith((ref) => chatRepo),
      ];

  setUp(() {
    alertRepo = FakeAlertRepository();
    reportRepo = FakeReportRepository();
    chatRepo = FakeChatRepository();
    container = ProviderContainer(overrides: overridesFor(ana).cast());
  });
  tearDown(() => container.dispose());

  /// Waits for the fake session so auth-gated streams start.
  Future<void> signIn(ProviderContainer c) async {
    c.listen(currentUserProvider, (_, _) {});
    await c.read(authSessionProvider.future);
    await c.read(currentUserProvider.future);
  }

  /// Keeps auto-dispose providers alive and waits for their streams to emit.
  Future<void> load(ProviderListenable<Object?> provider) async {
    for (final p in [provider, barangaysProvider, alertsProvider, readAlertIdsProvider]) {
      container.listen(p, (_, _) {});
    }
    await signIn(container);
    await container.read(barangaysProvider.future);
    await container.read(alertsProvider.future);
    await container.read(readAlertIdsProvider.future);
  }

  group('seed data', () {
    test('barangays are complete and in range', () {
      expect(seedBarangays, hasLength(24));
      expect(seedBarangays.map((b) => b.name).toSet(), hasLength(24));
      for (final b in seedBarangays) {
        expect(['High', 'Medium', 'Low'], contains(b.riskLevel), reason: b.name);
        for (final r in [b.floodRisk, b.heatRisk]) {
          expect(r, inInclusiveRange(0, 1), reason: b.name);
        }
        expect(b.historicalTemperatures, hasLength(6), reason: b.name);
      }
    });

    test('alerts are flood or heat and point at real barangays', () {
      final names = seedBarangays.map((b) => b.name).toSet();
      for (final a in seedAlerts) {
        expect(names, contains(a.barangayName), reason: a.id);
        expect(['flood', 'heat'], contains(a.type), reason: a.id);
      }
    });
  });

  test('login and a verified email are required everywhere', () {
    expect(authRedirect(AuthStatus.unknown, '/dashboard'), isNull, reason: 'still restoring the session');
    expect(authRedirect(AuthStatus.signedOut, '/dashboard'), '/login');
    expect(authRedirect(AuthStatus.signedOut, '/verify'), '/login');
    expect(authRedirect(AuthStatus.signedOut, '/login'), isNull);
    expect(authRedirect(AuthStatus.unverified, '/dashboard'), '/verify');
    expect(authRedirect(AuthStatus.unverified, '/login'), '/verify');
    expect(authRedirect(AuthStatus.unverified, '/verify'), isNull);
    expect(authRedirect(AuthStatus.verified, '/login'), '/dashboard');
    expect(authRedirect(AuthStatus.verified, '/verify'), '/dashboard');
    expect(authRedirect(AuthStatus.verified, '/messages/ana'), isNull);
  });

  test('unverified accounts get no data streams', () async {
    final c = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository(ana, verified: false)),
    ]);
    addTearDown(c.dispose);
    c.listen(authUidProvider, (_, _) {});
    c.listen(currentUserProvider, (_, _) {}); // unlistened providers are paused
    await c.read(authSessionProvider.future);
    expect(c.read(authUidProvider), isNull);
    expect(await c.read(currentUserProvider.future), isNull);
  });

  test('dashboard stats add up', () async {
    await load(dashboardStatsProvider);
    final stats = container.read(dashboardStatsProvider).requireValue;

    expect(stats.totalBarangays, 24);
    expect(stats.highRiskCount + stats.mediumRiskCount + stats.lowRiskCount, 24);
    expect(stats.populationAtRisk, lessThanOrEqualTo(stats.totalPopulation));
    expect(stats.overallRiskScore, inInclusiveRange(0, 100));
  });

  test('read state starts empty, persists, and drives the unread count', () async {
    await load(unreadAlertsCountProvider);
    expect(container.read(unreadAlertsCountProvider), seedAlerts.length);

    await container.read(readAlertIdsProvider.notifier).markAsRead(['alert_001']);
    expect(container.read(unreadAlertsCountProvider), seedAlerts.length - 1);
    expect(alertRepo.saved, {'alert_001'});

    await container.read(readAlertIdsProvider.notifier).markAsRead(seedAlerts.map((a) => a.id));
    expect(container.read(unreadAlertsCountProvider), 0);
  });

  test('saved read state is restored', () async {
    alertRepo.saved = {'alert_002'};
    await load(alertListProvider);
    final read = container.read(alertListProvider).requireValue.where((a) => a.isRead);
    expect(read.map((a) => a.id), ['alert_002']);
  });

  test('filters narrow alerts and barangays', () async {
    await load(filteredAlertsProvider);
    container.read(alertTypeFilterProvider.notifier).setFilter('flood');
    final alerts = container.read(filteredAlertsProvider).requireValue;
    expect(alerts, isNotEmpty);
    expect(alerts.every((a) => a.type == 'flood'), isTrue);

    container.listen(filteredBarangaysProvider, (_, _) {});
    container.read(riskFilterProvider.notifier).setFilter('High');
    final high = container.read(filteredBarangaysProvider).requireValue;
    expect(high, isNotEmpty);
    expect(high.every((b) => b.riskLevel == 'High'), isTrue);
  });

  test('residents see their own reports, admins see all', () async {
    container.listen(reportsProvider, (_, _) {});
    await signIn(container);
    expect((await container.read(reportsProvider.future)).map((r) => r.id), ['r1']);

    final admin = ProviderContainer(overrides: overridesFor(staff).cast());
    addTearDown(admin.dispose);
    admin.listen(reportsProvider, (_, _) {});
    await signIn(admin);
    expect((await admin.read(reportsProvider.future)).map((r) => r.id), ['r1', 'r2']);
  });

  test('temperature months end at the current month and wrap the year', () {
    final feb = DateTime(2026, 2, 10);
    expect(
      [for (var i = 0; i < 6; i++) TemperatureLineChart.monthLabel(i, 6, feb)],
      ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
    );
  });

  test('time ago labels', () {
    final now = DateTime(2026, 10, 18, 12);
    expect(AlertCard.timeAgo(now.subtract(const Duration(seconds: 20)), now), 'Just now');
    expect(AlertCard.timeAgo(now.subtract(const Duration(minutes: 15)), now), '15m ago');
    expect(AlertCard.timeAgo(now.subtract(const Duration(hours: 3)), now), '3h ago');
    expect(AlertCard.timeAgo(now.subtract(const Duration(days: 2)), now), '2d ago');
  });

  group('screens render', () {
    Future<void> pumpScreen(WidgetTester tester, Widget screen, {AppUser user = ana}) async {
      await tester.pumpWidget(ProviderScope(
        overrides: overridesFor(user).cast(),
        child: MaterialApp(
          theme: AppTheme.build(Brightness.light, font: (t) => t),
          darkTheme: AppTheme.build(Brightness.dark, font: (t) => t),
          home: screen,
        ),
      ));
      await tester.pump(); // let the fake streams emit
      await tester.pump();
      await tester.pump(const Duration(seconds: 1)); // and the FAB finish animating in
    }

    testWidgets('dashboard', (tester) async {
      await pumpScreen(tester, const DashboardScreen());
      expect(find.text('Tanaw'), findsWidgets);
      expect(find.text('Overall risk score'), findsOneWidget);
      expect(find.text('Barangays'), findsOneWidget);
      expect(find.byTooltip('Account'), findsOneWidget);
    });

    testWidgets('alerts, then tapping one marks it read', (tester) async {
      await pumpScreen(tester, const AlertsScreen());
      expect(find.text('Mark all read'), findsOneWidget);
      expect(find.text('Earthquake'), findsNothing);

      await tester.tap(find.text(seedAlerts.first.title));
      await tester.pumpAndSettle();
      expect(alertRepo.saved, {seedAlerts.first.id});
      expect(find.text('Got it'), findsOneWidget);
    });

    testWidgets('a resident submits a flood report', (tester) async {
      await pumpScreen(tester, const ReportsScreen());
      expect(find.text('My reports'), findsWidgets);
      expect(find.text('Water rising near the bridge'), findsOneWidget);

      await tester.tap(find.text('New report'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(find.text('Pick the barangay'), findsOneWidget);
      expect(find.text('Describe what you see'), findsOneWidget);
      expect(reportRepo.submitted, isEmpty);

      await tester.tap(find.text('Barangay'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bued').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, 'What is happening?'), '  Road flooded  ');
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();
      expect(reportRepo.submitted, [
        {'uid': 'ana', 'type': 'flood', 'barangay': 'Bued', 'details': 'Road flooded'},
      ]);
    });

    testWidgets('an admin sees every report', (tester) async {
      await pumpScreen(tester, const ReportsScreen(), user: staff);
      expect(find.text('All reports'), findsWidgets);
      expect(find.text('New report'), findsNothing);
      expect(find.text('Very hot at the market'), findsOneWidget);
    });

    testWidgets('a resident messages the MDRRMO', (tester) async {
      await pumpScreen(tester, const MessagesScreen());
      expect(find.text('MDRRMO Binalonan'), findsOneWidget);
      expect(find.text('Not yet, use the highway.'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Thank you!');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(chatRepo.sent, ['Thank you!']);
    });

    testWidgets('verify screen resends the email and says when not verified yet', (tester) async {
      final auth = FakeAuthRepository(ana, verified: false);
      await tester.pumpWidget(ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(auth)],
        child: MaterialApp(theme: AppTheme.build(Brightness.light, font: (t) => t), home: const VerifyEmailScreen()),
      ));
      await tester.pump();
      expect(find.textContaining('ana@x.ph'), findsOneWidget);

      await tester.tap(find.text('Send the email again'));
      await tester.pump();
      expect(auth.verificationEmails, 1);

      await tester.tap(find.text("I've verified my email"));
      await tester.pump();
      await tester.pump(); // snackbar shows after the async check returns
      expect(find.textContaining('Not verified yet'), findsOneWidget);
    });

    testWidgets('an admin sees the inbox', (tester) async {
      await pumpScreen(tester, const MessagesScreen(), user: staff);
      expect(find.text('Messages'), findsWidgets);
      expect(find.text('Ana Cruz'), findsOneWidget);
    });
  });
}
