import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';

/// Friendly text for Firebase Auth errors.
String authErrorMessage(Object error) {
  if (error is! FirebaseAuthException) return 'Something went wrong. Try again.';
  switch (error.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Wrong email or password.';
    case 'email-already-in-use':
      return 'An account with this email already exists. Sign in instead.';
    case 'weak-password':
      return 'Use a password with at least 6 characters.';
    case 'invalid-email':
      return 'That email address looks wrong.';
    case 'network-request-failed':
      return 'No internet connection.';
    case 'too-many-requests':
      return 'Too many attempts. Wait a moment and try again.';
    default:
      return error.message ?? 'Something went wrong. Try again.';
  }
}

/// Sign in or create an account. The router leaves this screen on its own
/// once a user is signed in.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final repo = ref.read(authRepositoryProvider);
    try {
      if (_register) {
        await repo.register(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
      } else {
        await repo.signIn(email: _email.text.trim(), password: _password.text);
      }
    } catch (e) {
      if (mounted) _show(authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      _show('Type your email above first.');
      return;
    }
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
      _show('Password reset link sent to $email.');
    } catch (e) {
      _show(authErrorMessage(e));
    }
  }

  void _show(String message) =>
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // show the newest message now, not after the last one times out
      ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ShapeIcon(
                          icon: Icons.shield_rounded,
                          shape: MaterialShapes.cookie9Sided,
                          color: theme.colorScheme.primary,
                          size: 96,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Tanaw', textAlign: TextAlign.center, style: theme.textTheme.displaySmall),
                      Text(
                        'Flood and heat risk in Binalonan',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 32),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('Sign in')),
                          ButtonSegment(value: true, label: Text('Create account')),
                        ],
                        selected: {_register},
                        onSelectionChanged: (s) => setState(() => _register = s.first),
                      ),
                      const SizedBox(height: 24),
                      if (_register) ...[
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          validator: (v) => (v ?? '').trim().isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                            hintText: '09XX XXX XXXX',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: (v) => RegExp(r'^\+?[0-9 -]{7,15}$').hasMatch((v ?? '').trim())
                              ? null
                              : 'Enter a valid mobile number',
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (v) => (v ?? '').trim().contains('@') ? null : 'Enter your email',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: _hidePassword ? 'Show password' : 'Hide password',
                            icon: Icon(_hidePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                            onPressed: () => setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                        autofillHints: [_register ? AutofillHints.newPassword : AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => (v ?? '').length < 6 ? 'At least 6 characters' : null,
                      ),
                      if (!_register)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: _resetPassword, child: const Text('Forgot password?')),
                        ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                        child: _busy
                            ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3))
                            : Text(_register ? 'Create account' : 'Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
