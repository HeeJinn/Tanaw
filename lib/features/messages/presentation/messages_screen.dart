import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b_risk/core/contacts.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/alerts/presentation/widgets/alert_card.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/messages/presentation/providers/chat_providers.dart';
import 'package:b_risk/features/messages/presentation/widgets/chat_view.dart';

/// Residents: their conversation with the MDRRMO. Admins: the inbox.
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const Scaffold(body: LoadingState());
    if (user.isAdmin) return const _Inbox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MDRRMO Binalonan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonalIcon(
              onPressed: () => callNumber(kRescueHotline),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Call'),
            ),
          ),
        ],
      ),
      body: ChatView(threadUid: user.uid),
    );
  }
}

class _Inbox extends ConsumerWidget {
  const _Inbox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threads = ref.watch(chatThreadsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Messages')),
          ...threads.when(
            loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
            error: (e, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: "Couldn't load messages.",
                  onRetry: () => ref.invalidate(chatThreadsProvider),
                ),
              ),
            ],
            data: (threads) => [
              if (threads.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No conversations yet.',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: threads.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (context, i) {
                      final t = threads[i];
                      return Material(
                        color: theme.colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(borderRadius: groupedRadius(i, threads.length)),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          onTap: () => context.go('/messages/${t.uid}'),
                          leading: CircleAvatar(child: Text(t.userName.isEmpty ? '?' : t.userName[0].toUpperCase())),
                          title: Text(t.userName, style: theme.textTheme.titleMedium),
                          subtitle: Text(t.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: Text(AlertCard.timeAgo(t.updatedAt, DateTime.now())),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// An admin's view of one resident's conversation.
class ChatScreen extends ConsumerWidget {
  final String threadUid;

  const ChatScreen({super.key, required this.threadUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thread = ref.watch(chatThreadProvider(threadUid)).value;
    final phone = thread?.userPhone;

    return Scaffold(
      appBar: AppBar(
        title: Text(thread?.userName ?? 'Resident'),
        actions: [
          if (phone != null)
            IconButton.filledTonal(
              tooltip: 'Call $phone',
              onPressed: () => callNumber(phone),
              icon: const Icon(Icons.call_rounded),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: ChatView(threadUid: threadUid),
    );
  }
}
