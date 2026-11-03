import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AuthRepositoryImpl({required this.auth, required this.firestore});

  // idTokenChanges, not authStateChanges: it also fires when refreshEmailVerified
  // gets a new token after the link is clicked
  @override
  Stream<AuthSession?> watchSession() => auth.idTokenChanges().map((user) =>
      user == null ? null : (uid: user.uid, email: user.email ?? '', emailVerified: user.emailVerified));

  @override
  Stream<AppUser> watchProfile(String uid) {
    return firestore.doc('users/$uid').snapshots().map((doc) {
      if (doc.exists) return AppUser.fromJson(doc.data()!);
      // Accounts made before profiles existed have no users doc
      final user = auth.currentUser;
      return AppUser(
        uid: uid,
        name: user?.displayName ?? user?.email ?? 'Resident',
        email: user?.email ?? '',
      );
    });
  }

  @override
  Future<void> signIn({required String email, required String password}) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    try {
      await firestore.doc('users/${user.uid}').set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      await user.updateDisplayName(name);
    } catch (_) {
      // Don't leave an account without a profile behind
      await user.delete();
      rethrow;
    }
    // If this fails the verify screen offers to resend, so don't undo the account
    await user.sendEmailVerification().catchError((_) {});
  }

  @override
  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }

  @override
  Future<bool> refreshEmailVerified() async {
    final user = auth.currentUser;
    if (user == null) return false;
    await user.reload();
    final verified = auth.currentUser?.emailVerified ?? false;
    // Firestore rules read email_verified from the ID token, so get a fresh one
    if (verified) await auth.currentUser!.getIdToken(true);
    return verified;
  }

  @override
  Future<void> sendPasswordReset(String email) => auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() => auth.signOut();
}
