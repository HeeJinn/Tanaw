// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(barangayLocalDataSource)
final barangayLocalDataSourceProvider = BarangayLocalDataSourceProvider._();

final class BarangayLocalDataSourceProvider
    extends
        $FunctionalProvider<
          BarangayLocalDataSource,
          BarangayLocalDataSource,
          BarangayLocalDataSource
        >
    with $Provider<BarangayLocalDataSource> {
  BarangayLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barangayLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barangayLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<BarangayLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarangayLocalDataSource create(Ref ref) {
    return barangayLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarangayLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarangayLocalDataSource>(value),
    );
  }
}

String _$barangayLocalDataSourceHash() =>
    r'4ac238a85de0bf723e9c4fb40aa1613988bdd8ba';

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
    r'7bbb0b89ab9897be25c4c1111f138a8bba70501b';

@ProviderFor(barangays)
final barangaysProvider = BarangaysProvider._();

final class BarangaysProvider
    extends $FunctionalProvider<List<Barangay>, List<Barangay>, List<Barangay>>
    with $Provider<List<Barangay>> {
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
  $ProviderElement<List<Barangay>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Barangay> create(Ref ref) {
    return barangays(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Barangay> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Barangay>>(value),
    );
  }
}

String _$barangaysHash() => r'844ff9ae75106931739b0e7bb262e8800eb596a0';

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
        isAutoDispose: true,
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

String _$selectedBarangayHash() => r'9ef344e3fb085eeca5cb68a512e68b93cc56e1a4';

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

@ProviderFor(HoveredBarangay)
final hoveredBarangayProvider = HoveredBarangayProvider._();

final class HoveredBarangayProvider
    extends $NotifierProvider<HoveredBarangay, Barangay?> {
  HoveredBarangayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hoveredBarangayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hoveredBarangayHash();

  @$internal
  @override
  HoveredBarangay create() => HoveredBarangay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Barangay? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Barangay?>(value),
    );
  }
}

String _$hoveredBarangayHash() => r'dc50a14f583425e966d82b1c0f0fa63d2f8240c1';

abstract class _$HoveredBarangay extends $Notifier<Barangay?> {
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
