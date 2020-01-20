class TvAttributes {
  final String name;
  final String overview;
  final String backdrop_path;
  final String poster_path;
  final String first_air_date;
  final int id;
  final double popularity;

  TvAttributes(this.name, this.overview, this.backdrop_path, this.poster_path,
      this.first_air_date, this.id,
      {this.popularity});
}
