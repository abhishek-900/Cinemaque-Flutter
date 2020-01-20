class Test {
  final List<People> results;
  Test({this.results});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(results: parse(json));
  }
  static List<People> parse(resultsjson) {
    var list = resultsjson["results"] as List;
    List<People> peoplelist =
        list.map((data) => People.fromjson(data)).toList();
    return peoplelist;
  }
}

class People {
  String profile_path;
  String name;
  int id;
  String known_for_department;
  double popularity;
  List<KnownFor> known_for;
  People(
      {this.profile_path,
      this.name,
      this.id,
      this.known_for_department,
      this.popularity,
      this.known_for});
  factory People.fromjson(Map<String, dynamic> json) {
    return People(
        profile_path: json["profile_path"],
        name: json["name"],
        id: json["id"],
        known_for_department: json["known_for_department"],
        popularity: json["popularity"],
        known_for: parse(json));
  }
  static List<KnownFor> parse(knownforjson) {
    var list = knownforjson["known_for"] as List;
    List<KnownFor> klist = list.map((data) => KnownFor.fromjson(data)).toList();
    return klist;
  }
}

class KnownFor {
  int id;
  String media_type;
  String title;
  String poster_path;
  String overview;
  String release_date;
  KnownFor(
      {this.id,
      this.media_type,
      this.title,
      this.poster_path,
      this.overview,
      this.release_date});
  factory KnownFor.fromjson(Map<String, dynamic> json1) {
    return KnownFor(
        id: json1["id"] as int,
        media_type: json1["media_type"] as String,
        title: json1["title"] as String,
        poster_path: json1["poster_path"] as String,
        overview: json1["overview"] as String,
        release_date: json1["release_date"] as String);
  }
}