import 'package:b_risk/features/auth/domain/entities/app_user.dart';

typedef AuthSession = ({String uid, String email, bool emailVerified});

abstract class AuthRepository {
  /// The signed-in account, or null when signed out.
  Stream<AuthSession?> watchSession();
  Stream<AppUser> watchProfile(String uid);
  Future<void> signIn({required String email, required String password});

  /// Creates the account and profile, then emails a verification link.
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  Future<void> sendEmailVerification();

  /// Re-checks with Firebase whether the link was clicked; true once verified.
  Future<bool> refreshEmailVerified();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}
