import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

/// Notices the person closed, so the same hint does not come back every
/// time. Keys include the state they are about (for example
/// `tmdb:notConfigured`), so a new problem shows again.
class DismissedNotices extends Notifier<Set<String>> {
  static const _key = 'dismissed_notices';

  @override
  Set<String> build() =>
      (ref.watch(sharedPreferencesProvider).getStringList(_key) ?? const [])
          .toSet();

  bool isDismissed(String notice) => state.contains(notice);

  Future<void> dismiss(String notice) async {
    state = {...state, notice};
    await ref
        .read(sharedPreferencesProvider)
        .setStringList(_key, state.toList());
  }
}

final dismissedNoticesProvider =
    NotifierProvider<DismissedNotices, Set<String>>(DismissedNotices.new);
