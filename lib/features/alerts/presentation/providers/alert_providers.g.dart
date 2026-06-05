// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alertLocalDataSource)
final alertLocalDataSourceProvider = AlertLocalDataSourceProvider._();

final class AlertLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AlertLocalDataSource,
          AlertLocalDataSource,
          AlertLocalDataSource
        >
    with $Provider<AlertLocalDataSource> {
  AlertLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AlertLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlertLocalDataSource create(Ref ref) {
    return alertLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertLocalDataSource>(value),
    );
  }
}

String _$alertLocalDataSourceHash() =>
    r'363fb07e2ff02acfa18e81089eacee7de3c94a49';

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

String _$alertRepositoryHash() => r'd11c270bbd74916baaad73efff6ed416834145aa';

@ProviderFor(AlertList)
final alertListProvider = AlertListProvider._();

final class AlertListProvider
    extends $NotifierProvider<AlertList, List<Alert>> {
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
  AlertList create() => AlertList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Alert> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Alert>>(value),
    );
  }
}

String _$alertListHash() => r'25cbbe64fdd1e864bc5ecd82345b45939e408f5d';

abstract class _$AlertList extends $Notifier<List<Alert>> {
  List<Alert> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Alert>, List<Alert>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Alert>, List<Alert>>,
              List<Alert>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

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

String _$unreadAlertsCountHash() => r'704af22db2ec1055875e4af1c1b8564a70211a7e';

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
    extends $FunctionalProvider<List<Alert>, List<Alert>, List<Alert>>
    with $Provider<List<Alert>> {
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
  $ProviderElement<List<Alert>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Alert> create(Ref ref) {
    return filteredAlerts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Alert> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Alert>>(value),
    );
  }
}

String _$filteredAlertsHash() => r'b97ee8887d9566c72f03a57908d9d4466e58529f';
