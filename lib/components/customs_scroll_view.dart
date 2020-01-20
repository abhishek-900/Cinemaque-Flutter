import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinemaque/model/Tv.dart';
import 'package:cinemaque/movie/movie_review.dart';
import 'package:cinemaque/model/popular_movies.dart';
import 'package:cinemaque/model/trending.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cinemaque/tv/tv_review_page.dart';
import 'dart:convert';
import 'package:cinemaque/model/upcoming_movies.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with AutomaticKeepAliveClientMixin<FirstPage> {
  @override
  bool get wantKeepAlive => true;

  List<Trending> trend = [];
  List<UpcomingM> up = [];
  List<PopularM> pop = [];
  List<TvAttributes> show = [];
  List<TvAttributes> showup = [];
  Future<List<TvAttributes>> _future1;
  Future<List<TvAttributes>> _future2;
  Future<List<PopularM>> _future3;
  Future<List<UpcomingM>> _future4;
  Future<List<Trending>> _future5;

  Future<Null> _refresh1() async {
    setState(() {
      _future1 = _getTv();
    });
    return null;
  }
  Future<Null> _refresh2() async {
    setState(() {
      _future2 = _getTvShows();
    });
    return null;
  }
  Future<Null> _refresh3() async {
    setState(() {
      _future3 = _popVideo();
    });
    return null;
  }
  Future<Null> _refresh4() async {
    setState(() {
      _future4 = _upVideo();
    });
    return null;
  }
  Future<Null> _refresh5() async {
    setState(() {
      _future5 = _trendVideo();
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _future1 = _getTv();
      _future2 = _getTvShows();
      _future3 = _popVideo();
      _future4 = _upVideo();
      _future5 = _trendVideo();
      noColor = Color(0xffe6e6e6);
      noText = TextStyle(color: Colors.black);
      yesText = TextStyle(color: Colors.white);
      yesColor = Color(0xffff0000);
    });
  }
  Future<List<TvAttributes>> _getTv() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/popular?api_key= ------- user you moviedb key here -----------");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];
    for (var u in info1) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      showup.add(t);
    }
    return showup;
  }
  Future<List<TvAttributes>> _getTvShows() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/top_rated?api_key=------- user you moviedb key here -----------");
    var jsonData2 = json.decode(data1.body);
    var info2 = jsonData2["results"];

    for (var u in info2) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'],
          popularity: u["popularity"]);
      show.add(t);
    }
    return show;
  }
  Future<List<PopularM>> _popVideo() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/movie/popular?api_key=------- user you moviedb key here -----------");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];
    for (var u in info1) {
      PopularM v = PopularM(u["title"], u["poster_path"], u["overview"],
          u["release_date"], u["backdrop_path"], u["id"], u["popularity"]);
      pop.add(v);
    }
    return pop;
  }
  Future<List<UpcomingM>> _upVideo() async {
    var data1 = await http.get("https://api.themoviedb.org/3/movie/upcoming?api_key=------- user you moviedb key here -----------");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];

    for(var u in info1){
      UpcomingM v = UpcomingM(u["title"], u["poster_path"], u["overview"], u["release_date"], u["id"], u["backdrop_path"], u["popularity"]);
      up.add(v);
    }

    return up;
  }
  Future<List<Trending>> _trendVideo() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/trending/movie/day?api_key=------- user you moviedb key here -----------");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];
    for (var u in info1) {
      Trending v = Trending(u["title"], u["poster_path"], u["overview"],
          u["release_date"], u["backdrop_path"], u["id"], u["popularity"]);
      trend.add(v);
    }
    return trend;
  }
  Color noColor;
  Color yesColor;
  TextStyle noText;
  TextStyle yesText;
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              " Are you sure you want to quit the app ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  MaterialButton(
                      color: noColor,
                      child: Text("No", style: noText),
                      onPressed: () {
                        setState(() {
                          noColor = Color(0xffff0000);
                          yesColor = Color(0xffe6e6e6);
                          noText = TextStyle(color: Colors.white);
                          yesText = TextStyle(color: Colors.black);
                        });
                        Navigator.pop(context);
                      }),
                  Padding(padding: EdgeInsets.only(right: 50.0)),
                  MaterialButton(
                      color: yesColor,
                      child: Text("Yes", style: yesText),
                      onPressed: () {
                        SystemNavigator.pop();
                      }),
                  Padding(
                    padding: EdgeInsets.only(right: 50.0),
                  ),
                ],
              ),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => createAlertDialog(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Hero(
          tag: "pic",
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                pinned: false,
                expandedHeight: screenheight * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      height: screenheight * 0.28,
                      width: screenwidth,
                      color: Colors.black,
                      child: FutureBuilder(
                          future: _future4,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                onRefresh: _refresh4,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieReview(
                                                        snapshot.data[index]
                                                            .poster_path,
                                                        snapshot
                                                            .data[index].title,
                                                        snapshot.data[index]
                                                            .overview,
                                                        snapshot.data[index]
                                                            .release_date,
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .popularity,
                                                        snapshot.data[index].backdrop_path
                                                      )));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: screenheight * 0.28,
                                              width: screenwidth,
                                              child: snapshot.data[index]
                                                          .backdrop_path !=
                                                      null
                                                  ? Image.network(
                                                      "https://image.tmdb.org/t/p/w500" +
                                                          snapshot.data[index]
                                                              .backdrop_path,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.network(
                                                      "https://image.tmdb.org/t/p/w500" +
                                                          snapshot
                                                              .data[index + 1]
                                                              .backdrop_path,
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                            Banner(),
                                          ],
                                        ),
                                      );
                                    }),
                              );
                            }
                          })),
                ),
              ),

             titles(" Upcoming Movies ", screenwidth, screenheight),
              SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    width: 200,
                    child: FutureBuilder(
                        future: _future4,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refresh4,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, right: 10, left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieReview(
                                                        snapshot.data[index]
                                                            .poster_path,
                                                        snapshot
                                                            .data[index].title,
                                                        snapshot.data[index]
                                                            .overview,
                                                        snapshot.data[index]
                                                            .release_date,
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .popularity,
                                                          snapshot.data[index].backdrop_path
                                                      )));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 150,
                                              width: 200,
                                              child: Image.network(
                                                snapshot.data[index]
                                                            .backdrop_path !=
                                                        null
                                                    ? "https://image.tmdb.org/t/p/w500" +
                                                        snapshot.data[index]
                                                            .backdrop_path
                                                    : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Positioned(
                                              top: 80,
                                              bottom: 0,
                                              child: Container(
                                                width: 200,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  snapshot.data[index].title,
                                                  style: TextStyle(
                                                      fontFamily: 'fira',
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        })),
              ),
              titles(" Trending Movies ", screenwidth, screenheight),
              SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    width: 200,
                    child: FutureBuilder(
                        future: _future5,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refresh5,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, right: 10, left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieReview(
                                                        snapshot.data[index]
                                                            .poster_path,
                                                        snapshot
                                                            .data[index].title,
                                                        snapshot.data[index]
                                                            .overview,
                                                        snapshot.data[index]
                                                            .release_date,
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .popularity,
                                                          snapshot.data[index].backdrop_path
                                                      )));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 150,
                                              width: 200,
                                              child: Image.network(
                                                snapshot.data[index]
                                                            .backdrop_path !=
                                                        null
                                                    ? "https://image.tmdb.org/t/p/w500" +
                                                        snapshot.data[index]
                                                            .backdrop_path
                                                    : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Positioned(
                                              top: 80,
                                              bottom: 0,
                                              child: Container(
                                                width: 200,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  snapshot.data[index].title,
                                                  style: TextStyle(
                                                      fontFamily: 'fira',
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        })),
              ),
              titles(" Popular Movies ", screenwidth, screenheight),
              SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    width: 200,
                    child: FutureBuilder(
                        future: _future3,
                        builder: (context, snapshot) {

                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refresh3,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, right: 10, left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieReview(
                                                        snapshot.data[index]
                                                            .poster_path,
                                                        snapshot
                                                            .data[index].title,
                                                        snapshot.data[index]
                                                            .overview,
                                                        snapshot.data[index]
                                                            .release_date,
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .popularity,
                                                          snapshot.data[index].backdrop_path
                                                      )));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 150,
                                              width: 200,
                                              child: Image.network(
                                                snapshot.data[index]
                                                    .backdrop_path !=
                                                    null
                                                    ? "https://image.tmdb.org/t/p/w500" +
                                                    snapshot.data[index]
                                                        .backdrop_path
                                                    : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Positioned(
                                              top: 80,
                                              bottom: 0,
                                              child: Container(
                                                width: 200,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  snapshot.data[index].title,
                                                  style: TextStyle(
                                                      fontFamily: 'fira',
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                      FontWeight.bold),
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
                        })),
              ),
              titles(" Popular TvShows ", screenwidth, screenheight),
              SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    width: 200,
                    child: FutureBuilder(
                        future: _future1,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refresh1,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, right: 10, left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TvReviewPage(
                                                        snapshot
                                                            .data[index].name,
                                                        snapshot.data[index]
                                                            .overview,
                                                        snapshot.data[index]
                                                            .backdrop_path,
                                                        snapshot.data[index]
                                                            .poster_path,
                                                        snapshot.data[index]
                                                            .first_air_date,
                                                        snapshot.data[index].id,
                                                        popularity: snapshot
                                                            .data[index]
                                                            .popularity,
                                                      )));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                                height: 150,
                                                width: 200,
                                                child: Image.network(
                                                  snapshot.data[index]
                                                              .backdrop_path !=
                                                          null
                                                      ? "https://image.tmdb.org/t/p/w500" +
                                                          snapshot.data[index]
                                                              .backdrop_path
                                                      : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                  fit: BoxFit.fill,
                                                )),
                                            Positioned(
                                              top: 80,
                                              bottom: 0,
                                              child: Container(
                                                width: 200,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                      fontFamily: 'fira',
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        })),
              ),
              titles(" Top Rated TvShows  ", screenwidth, screenheight),
            SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    width: 200,
                    child: FutureBuilder(
                        future: _future2,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refresh2,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, right: 10, left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TvReviewPage(
                                                          snapshot
                                                              .data[index].name,
                                                          snapshot.data[index]
                                                              .overview,
                                                          snapshot.data[index]
                                                              .backdrop_path,
                                                          snapshot.data[index]
                                                              .poster_path,
                                                          snapshot.data[index]
                                                              .first_air_date,
                                                          snapshot
                                                              .data[index].id,
                                                          popularity: snapshot
                                                              .data[index]
                                                              .popularity)));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                                height: 150,
                                                width: 200,
                                                child: Image.network(
                                                  snapshot.data[index]
                                                              .backdrop_path !=
                                                          null
                                                      ? "https://image.tmdb.org/t/p/w500" +
                                                          snapshot.data[index]
                                                              .backdrop_path
                                                      : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                  fit: BoxFit.fill,
                                                )),
                                            Positioned(
                                              top: 80,
                                              bottom: 0,
                                              child: Container(
                                                width: 200,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                      fontFamily: 'fira',
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget titles(String text, var scwidth, var scheight){
  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.only(top: 8),
      child: Container(
        width: scwidth,
        height: scheight * 0.12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 1.4),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 26,
            )
          ],
        ),
      ),
    ),
  );
}

class Banner extends StatefulWidget {
  @override
  _BannerState createState() => _BannerState();
}
class _BannerState extends State<Banner> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animation =
        Tween<double>(begin: 0.0, end: 18.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    animationController.forward();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20.0, left: 20.0),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.new_releases,color: Colors.red),
                ),
                Text(
                  "New Release",
                  style: TextStyle(fontSize: animation.value, fontFamily: 'fira', color: Colors.white),
                ),

              ],
            )));
  }
}
