import '../../shared/models/match_candidate.dart';
import '../network/tmdb/tmdb_models.dart';
import '../utils/title_normalizer.dart';

class MovieMatcher {
  const MovieMatcher();

  List<MatchCandidate> rank(
    String query,
    List<TmdbSearchResult> candidates, {
    int? year,
  }) {
    final scored = candidates.map((candidate) {
      var score = TitleNormalizer.similarity(query, candidate.title);
      if (candidate.originalTitle != null) {
        final altScore = TitleNormalizer.similarity(
          query,
          candidate.originalTitle!,
        );
        if (altScore > score) score = altScore;
      }
      if (year != null && candidate.releaseYear != null) {
        final diff = (candidate.releaseYear! - year).abs();
        if (diff == 0) {
          score += 0.08;
        } else if (diff <= 1) {
          score += 0.03;
        } else if (diff > 3) {
          score -= 0.05;
        }
      }
      return MatchCandidate(
        result: candidate,
        confidence: score.clamp(0.0, 1.0),
      );
    }).toList()..sort((a, b) => b.confidence.compareTo(a.confidence));
    return scored;
  }

  MatchCandidate? bestMatch(
    String query,
    List<TmdbSearchResult> candidates, {
    int? year,
  }) {
    final ranked = rank(query, candidates, year: year);
    return ranked.isEmpty ? null : ranked.first;
  }

  List<TvMatchCandidate> rankTv(
    String query,
    List<TmdbTvSearchResult> candidates, {
    int? year,
  }) {
    final scored = candidates.map((candidate) {
      var score = TitleNormalizer.similarity(query, candidate.name);
      if (candidate.originalName != null) {
        final altScore = TitleNormalizer.similarity(
          query,
          candidate.originalName!,
        );
        if (altScore > score) score = altScore;
      }
      if (year != null && candidate.firstAirYear != null) {
        final diff = (candidate.firstAirYear! - year).abs();
        if (diff == 0) {
          score += 0.08;
        } else if (diff <= 1) {
          score += 0.03;
        } else if (diff > 3) {
          score -= 0.05;
        }
      }
      return TvMatchCandidate(
        result: candidate,
        confidence: score.clamp(0.0, 1.0),
      );
    }).toList()..sort((a, b) => b.confidence.compareTo(a.confidence));
    return scored;
  }
}
