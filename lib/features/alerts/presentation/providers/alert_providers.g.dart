// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alertRepository)
final alertRepositoryProvider = AlertRepositoryProvider._();

final class AlertRepositoryProvider
    extends
        $FunctionalProvider<AlertRepository, AlertRepository, AlertRepository>
    with $Provider<AlertRepository> {
  AlertRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertRepositoryHash();

  @$internal
  @override
  $ProviderElement<AlertRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlertRepository create(Ref ref) {
    return alertRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertRepository>(value),
    );
  }
}

String _$alertRepositoryHash() => r'04b93d70a13f4432a9e6165b8a8fe6368cfbafd1';

@ProviderFor(alerts)
final alertsProvider = AlertsProvider._();

final class AlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Alert>>,
          List<Alert>,
          Stream<List<Alert>>
        >
    with $FutureModifier<List<Alert>>, $StreamProvider<List<Alert>> {
  AlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertsHash();

  @$internal
  @override
  $StreamProviderElement<List<Alert>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Alert>> create(Ref ref) {
    return alerts(ref);
  }
}

String _$alertsHash() => r'dc96b19c5f060ea13d29fe15925edf86cb882a71';

@ProviderFor(ReadAlertIds)
final readAlertIdsProvider = ReadAlertIdsProvider._();

final class ReadAlertIdsProvider
    extends $AsyncNotifierProvider<ReadAlertIds, Set<String>> {
  ReadAlertIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readAlertIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readAlertIdsHash();

  @$internal
  @override
  ReadAlertIds create() => ReadAlertIds();
}

String _$readAlertIdsHash() => r'83f2d1cec11da48131055e684b91f1aaf87cb594';

abstract class _$ReadAlertIds extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Alerts from the server, flagged with this device's read state.

@ProviderFor(alertList)
final alertListProvider = AlertListProvider._();

/// Alerts from the server, flagged with this device's read state.

final class AlertListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Alert>>,
          AsyncValue<List<Alert>>,
          AsyncValue<List<Alert>>
        >
    with $Provider<AsyncValue<List<Alert>>> {
  /// Alerts from the server, flagged with this device's read state.
  AlertListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertListHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Alert>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Alert>> create(Ref ref) {
    return alertList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Alert>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Alert>>>(value),
    );
  }
}

String _$alertListHash() => r'023d0b84885b4636d45855f0965498776885d3d2';

@ProviderFor(unreadAlertsCount)
final unreadAlertsCountProvider = UnreadAlertsCountProvider._();

final class UnreadAlertsCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadAlertsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadAlertsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadAlertsCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadAlertsCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadAlertsCountHash() => r'3d8fdfdae196627c4b1c5ca1abb64486d4775c99';

@ProviderFor(AlertTypeFilter)
final alertTypeFilterProvider = AlertTypeFilterProvider._();

final class AlertTypeFilterProvider
    extends $NotifierProvider<AlertTypeFilter, String> {
  AlertTypeFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertTypeFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertTypeFilterHash();

  @$internal
  @override
  AlertTypeFilter create() => AlertTypeFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$alertTypeFilterHash() => r'a0bb5710c52e3dff74234f16f6377ebc1b33f76e';

abstract class _$AlertTypeFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredAlerts)
final filteredAlertsProvider = FilteredAlertsProvider._();

final class FilteredAlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Alert>>,
          AsyncValue<List<Alert>>,
          AsyncValue<List<Alert>>
        >
    with $Provider<AsyncValue<List<Alert>>> {
  FilteredAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAlertsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAlertsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Alert>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Alert>> create(Ref ref) {
    return filteredAlerts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Alert>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Alert>>>(value),
    );
  }
}

String _$filteredAlertsHash() => r'd440f3b6dd06765a0fb8aeaf4c1689dad010f37e';
