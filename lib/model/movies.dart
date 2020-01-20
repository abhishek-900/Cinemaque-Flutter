class MovieAttributes {
  final String title;
  final String poster_path;
  final String overview;
  final String release_date;
  final String backdrop_path;
  final int id;
  final double popularity;
  final double vote_average;
  MovieAttributes(
    this.title,
    this.poster_path,
    this.overview,
    this.release_date,
    this.backdrop_path,
    this.id,
    this.popularity,
  {this.vote_average}
  );
}