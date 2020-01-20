import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinemaque/movie/movie_review.dart';
import 'package:cinemaque/model/movies.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin<MoviePage> {
  @override
  bool get wantKeepAlive => true;
  Future<List<MovieAttributes>> _future;
  List<MovieAttributes> users = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      _future = _getUsers();
    });
  }
  Future<List<MovieAttributes>> _getUsers() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/discover/movie?api_key=------- user you moviedb key here -----------&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page= 1");
    var data2 = await http.get(
        "https://api.themoviedb.org/3/discover/movie?api_key=------- user you moviedb key here -----------&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=2");
    var data3 = await http.get(
        "https://api.themoviedb.org/3/discover/movie?api_key=------- user you moviedb key here -----------&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=3");
    var jsonData1 = json.decode(data1.body);
    var jsonData2 = json.decode(data2.body);
    var jsonData3 = json.decode(data3.body);
    var info1 = jsonData1['results'];
    var info2 = jsonData2['results'];
    var info3 = jsonData3['results'];
    for (var u in info1) {
      MovieAttributes user = MovieAttributes(
        u["title"],
        u["poster_path"],
        u["overview"],
        u["release_date"],
        u["backdrop_path"],
        u["id"],
        u["popularity"]);
      users.add(user);
    }

    for (var u in info2) {
      MovieAttributes user = MovieAttributes(
        u["title"],
        u["poster_path"],
        u["overview"],
        u["release_date"],
        u["backdrop_path"],
        u["id"],
        u["popularity"],

      );
      users.add(user);
    }

    for (var u in info3) {
      MovieAttributes user = MovieAttributes(
        u["title"],
        u["poster_path"],
        u["overview"],
        u["release_date"],
        u["backdrop_path"],
        u["id"],
        u["popularity"],
      );
      users.add(user);
    }
return users;
  }
  Future<Null> _refresh() async {
    setState(() {
      _future = _getUsers();
    });
    return null;
  }
 @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.popAndPushNamed(context, "/first");
      },
      child: new Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                        child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )));
              } else {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieReview(
                                          snapshot.data[index].poster_path,
                                          snapshot.data[index].title,
                                          snapshot.data[index].overview,
                                          snapshot.data[index].release_date,
                                          snapshot.data[index].id,
                                          snapshot.data[index].popularity)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    height: 290,
                                    child: Image.network(
                                      snapshot.data[index].poster_path != null
                                          ? "https://image.tmdb.org/t/p/w500" +
                                              snapshot.data[index].poster_path
                                          : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                              Positioned(
                                top: 220,
                                bottom: 0,
                                child: Container(
                                  width: 176,
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Text(
                                      snapshot.data[index].title,
                                      style: TextStyle(
                                          fontFamily: 'fira',
                                          textBaseline:
                                          TextBaseline.alphabetic,
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
