import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
}

@Riverpod(keepAlive: true)
Stream<AuthSession?> authSession(Ref ref) {
  return ref.watch(authRepositoryProvider).watchSession();
}

/// The uid once signed in with a verified email, else null.
/// Firestore only serves verified users, so data streams wait for this.
@Riverpod(keepAlive: true)
String? authUid(Ref ref) {
  final session = ref.watch(authSessionProvider).value;
  return session != null && session.emailVerified ? session.uid : null;
}

/// The signed-in user's profile; null while signed out, unverified or loading.
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUser(Ref ref) {
  final uid = ref.watch(authUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(authRepositoryProvider).watchProfile(uid);
}

@riverpod
bool isAdmin(Ref ref) {
  return ref.watch(currentUserProvider).value?.isAdmin ?? false;
}
