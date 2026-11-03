import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';

/// App bar avatar that opens the account sheet with Sign out.
class AccountButton extends ConsumerWidget {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return IconButton(
      tooltip: 'Account',
      icon: CircleAvatar(
        radius: 18,
        child: Text(user == null || user.name.isEmpty ? '?' : user.name[0].toUpperCase()),
      ),
      onPressed: user == null
          ? null
          : () => showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  final theme = Theme.of(context);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(user.name, style: theme.textTheme.headlineSmall)),
                            if (user.isAdmin) const Chip(label: Text('Admin')),
                          ],
                        ),
                        Text(user.email, style: theme.textTheme.bodyLarge),
                        if (user.phone != null) Text(user.phone!, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 24),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(authRepositoryProvider).signOut();
                          },
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Sign out'),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
