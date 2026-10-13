import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../server/application/server_providers.dart';
import '../../server/data/library_repository.dart';
import '../../server/domain/server_models.dart';

final tvTitlesProvider = FutureProvider.autoDispose
    .family<List<ServerTitle>, String>((ref, kind) async {
      final page = await ref
          .watch(libraryRepositoryProvider)!
          .titles(TitleQuery(kind: kind), limit: 100);
      return page.items;
    });
