class Movie {
  late int? id;
  late String? title;
  late String? originalTitle;
  late String? overview;
  late String? releaseDate;
  late String? originalLanguage;
  late List<int>? genreIds;
  late String? posterPath;
  late String? backdropPath;
  late double? popularity;
  late double? voteAverage;
  late int? voteCount;
  late bool? adult;
  late bool? video;

  Movie(
    this.id,
    this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.originalLanguage,
    this.genreIds,
    this.posterPath,
    this.backdropPath,
    this.popularity,
    this.voteAverage,
    this.voteCount,
    this.adult,
    this.video,
  );

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      json['id'],
      json['title'] ?? '',
      json['original_title'] ?? '',
      json['overview'] ?? '',
      json['release_date'] ?? '',
      json['original_language'] ?? '',
      List<int>.from(json['genre_ids']),
      json['poster_path'] ?? '',
      json['backdrop_path'] ?? '',
      (json['popularity'] as num).toDouble(),
      (json['vote_average'] as num).toDouble(),
      json['vote_count'] ?? 0,
      json['adult'] ?? false,
      json['video'] ?? false,
    );
  }
  @override
  String toString() {
    return 'Movie($id, $title, $originalTitle, $overview, $releaseDate, '
        '$originalLanguage, $genreIds, $posterPath, $backdropPath, '
        '$popularity, $voteAverage, $voteCount, $adult, $video)';
  }
}
