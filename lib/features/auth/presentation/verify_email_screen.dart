import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/auth/presentation/auth_screen.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';

/// Shown to signed-in accounts whose email isn't verified yet. The router
/// moves on by itself once Firebase reports the email as verified.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _checking = false;

  Future<void> _check() async {
    setState(() => _checking = true);
    try {
      final verified = await ref.read(authRepositoryProvider).refreshEmailVerified();
      if (!verified) _show('Not verified yet. Open the link in the email first.');
    } catch (e) {
      _show(authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resend() async {
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      _show('Verification email sent. Check your inbox and spam folder.');
    } catch (e) {
      _show(authErrorMessage(e));
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // show the newest message now, not after the last one times out
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = ref.watch(authSessionProvider).value?.email ?? 'your email';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ShapeIcon(
                      icon: Icons.mark_email_unread_rounded,
                      shape: MaterialShapes.cookie9Sided,
                      color: theme.colorScheme.primary,
                      size: 96,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Verify your email', textAlign: TextAlign.center, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a verification link to $email. Open it, then come back and tap the button below.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _checking ? null : _check,
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                    child: const Text("I've verified my email"),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _resend,
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    child: const Text('Send the email again'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                    child: const Text('Use a different account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
