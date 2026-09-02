import 'collection_status.dart';
import 'tv_season.dart';
import 'tv_series.dart';

class TvSeriesWithSeasons {
  const TvSeriesWithSeasons({required this.series, required this.seasons});

  final TvSeries series;
  final List<TvSeason> seasons;

  List<TvSeason> get regularSeasons =>
      seasons.where((s) => s.seasonNumber > 0).toList();

  TvSeason? get specials {
    for (final season in seasons) {
      if (season.seasonNumber <= 0) return season;
    }
    return null;
  }

  int get ownedRegularCount =>
      regularSeasons.where((s) => s.status == CollectionStatus.owned).length;

  int get totalRegularCount => regularSeasons.length;

  String get progressLabel =>
      '$ownedRegularCount / $totalRegularCount Staffeln gekauft';
}

extension TvSeriesX on TvSeries {
  int? get firstAirYear => firstAirDate?.year;
}
