/// A signed-in person's profile from `users/{uid}`.
/// Admins are made by setting `role: "admin"` on that doc in the Firebase console.
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? role;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.role,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
    );
  }
}
