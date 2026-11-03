// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(barangayRemoteDataSource)
final barangayRemoteDataSourceProvider = BarangayRemoteDataSourceProvider._();

final class BarangayRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BarangayRemoteDataSource,
          BarangayRemoteDataSource,
          BarangayRemoteDataSource
        >
    with $Provider<BarangayRemoteDataSource> {
  BarangayRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barangayRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barangayRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BarangayRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarangayRemoteDataSource create(Ref ref) {
    return barangayRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarangayRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarangayRemoteDataSource>(value),
    );
  }
}

String _$barangayRemoteDataSourceHash() =>
    r'6173b97fce15693f08833401ba5fb5e41815144a';

@ProviderFor(barangayRepository)
final barangayRepositoryProvider = BarangayRepositoryProvider._();

final class BarangayRepositoryProvider
    extends
        $FunctionalProvider<
          BarangayRepository,
          BarangayRepository,
          BarangayRepository
        >
    with $Provider<BarangayRepository> {
  BarangayRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barangayRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barangayRepositoryHash();

  @$internal
  @override
  $ProviderElement<BarangayRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarangayRepository create(Ref ref) {
    return barangayRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarangayRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarangayRepository>(value),
    );
  }
}

String _$barangayRepositoryHash() =>
    r'45fa5048932737a0429c405c2a8305bcd9a9f012';

@ProviderFor(barangays)
final barangaysProvider = BarangaysProvider._();

final class BarangaysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Barangay>>,
          List<Barangay>,
          Stream<List<Barangay>>
        >
    with $FutureModifier<List<Barangay>>, $StreamProvider<List<Barangay>> {
  BarangaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barangaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barangaysHash();

  @$internal
  @override
  $StreamProviderElement<List<Barangay>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Barangay>> create(Ref ref) {
    return barangays(ref);
  }
}

String _$barangaysHash() => r'dfc3f22e2025a05ede9691ac4703ea53b9f6456f';

@ProviderFor(SelectedBarangay)
final selectedBarangayProvider = SelectedBarangayProvider._();

final class SelectedBarangayProvider
    extends $NotifierProvider<SelectedBarangay, Barangay?> {
  SelectedBarangayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBarangayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBarangayHash();

  @$internal
  @override
  SelectedBarangay create() => SelectedBarangay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Barangay? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Barangay?>(value),
    );
  }
}

String _$selectedBarangayHash() => r'2d24b2a70a0e0e59a3b7251c48ce9b8e4921cb39';

abstract class _$SelectedBarangay extends $Notifier<Barangay?> {
  Barangay? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Barangay?, Barangay?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Barangay?, Barangay?>,
              Barangay?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(RiskFilter)
final riskFilterProvider = RiskFilterProvider._();

final class RiskFilterProvider extends $NotifierProvider<RiskFilter, String> {
  RiskFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riskFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riskFilterHash();

  @$internal
  @override
  RiskFilter create() => RiskFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$riskFilterHash() => r'8664c891feacf2715bf341d8794f330a9357f76d';

abstract class _$RiskFilter extends $Notifier<String> {
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

@ProviderFor(filteredBarangays)
final filteredBarangaysProvider = FilteredBarangaysProvider._();

final class FilteredBarangaysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Barangay>>,
          AsyncValue<List<Barangay>>,
          AsyncValue<List<Barangay>>
        >
    with $Provider<AsyncValue<List<Barangay>>> {
  FilteredBarangaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredBarangaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredBarangaysHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Barangay>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Barangay>> create(Ref ref) {
    return filteredBarangays(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Barangay>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Barangay>>>(value),
    );
  }
}

String _$filteredBarangaysHash() => r'3554e6c77d4ecfe6d42fe48cfd62e9718e5fb42f';
