import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/repository_providers.dart';

final barcodesForMovieProvider = StreamProvider.family<List<BarcodeRow>, int>((
  ref,
  movieId,
) {
  return ref.watch(barcodeRepositoryProvider).watchBarcodesForMovie(movieId);
});
