import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env.dart';

/// Whether this build can ask TMDB for movie information. A provider (not
/// the static [Env] flag) so screens can be tested in both states.
final tmdbConfiguredProvider = Provider<bool>((ref) => Env.isTmdbConfigured);
