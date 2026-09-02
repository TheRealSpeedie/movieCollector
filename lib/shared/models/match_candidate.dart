import '../../core/network/tmdb/tmdb_models.dart';

class MatchCandidate {
  const MatchCandidate({required this.result, required this.confidence});

  final TmdbSearchResult result;
  final double confidence;
}

class TvMatchCandidate {
  const TvMatchCandidate({required this.result, required this.confidence});

  final TmdbTvSearchResult result;
  final double confidence;
}
