import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinemaque/model/Tv.dart';
import 'package:cinemaque/tv/tv_review_page.dart';

class Tvshows extends StatefulWidget {
  @override
  _TvshowsState createState() => _TvshowsState();
}
class _TvshowsState extends State<Tvshows>
    with AutomaticKeepAliveClientMixin<Tvshows> {
  @override
  bool get wantKeepAlive => true;
  List<TvAttributes> show = [];
  Future<List<TvAttributes>> _future;
  @override
  void initState() {
    super.initState();
    setState(() {
      _future = _getTvShows();
    });
  }
  Future<List<TvAttributes>> _getTvShows() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/popular?api_key=------- user you moviedb key here -----------&language=en-US&page=1");
    var data2 = await http.get(
        "https://api.themoviedb.org/3/tv/on_the_air?api_key=------- user you moviedb key here -----------&language=en-US&page=2");
    var data3 = await http.get(
        "https://api.themoviedb.org/3/tv/on_the_air?api_key=------- user you moviedb key here -----------&language=en-US&page=3");
    var jsonData1 = json.decode(data1.body);
    var jsonData2 = json.decode(data2.body);
    var jsonData3 = json.decode(data3.body);
    var jsonData4 = json.decode(data3.body);
    var info1 = jsonData1['results'];
    var info2 = jsonData2['results'];
    var info3 = jsonData3['results'];
    var info4 = jsonData4['results'];
    for (var u in info1) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      show.add(t);
    }
    for (var u in info2) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      show.add(t);
    }
    for (var u in info3) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      show.add(t);
    }
    for (var u in info4) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      show.add(t);
    }
    return show;
  }
  Future<Null> _refresh() async {
    setState(() {
      _future = _getTvShows();
    });
    return null;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
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
                                    builder: (context) => TvReviewPage(
                                          snapshot.data[index].name,
                                          snapshot.data[index].overview,
                                          snapshot.data[index].backdrop_path,
                                          snapshot.data[index].poster_path,
                                          snapshot.data[index].first_air_date,
                                          snapshot.data[index].id,
                                          popularity:
                                              snapshot.data[index].popularity,
                                        )));
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
                                        snapshot.data[index].name,
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
    );
  }
}
