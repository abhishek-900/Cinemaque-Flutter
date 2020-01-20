import 'package:flutter/material.dart';
import 'package:cinemaque/model/movies.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'movie_review.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  bool x = false;
  Future<List<MovieAttributes>> _future;
  List<MovieAttributes> search = [];
  String searchString = " ";
  String t;
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<MovieAttributes>> _getSearch(String s) async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/search/movie?api_key=------- user you moviedb key here -----------=en-US&query=$s&page=1&include_adult=false");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];
    for (var u in info1) {
      MovieAttributes v = MovieAttributes(
        u["title"],
        u["poster_path"],
        u["overview"],
        u["release_date"],
        u["backdrop_path"],
        u["id"],
        u["popularity"]
      );
      search.add(v);
    }
    return search;
  }
  Future<Null> _refresh() async {
    setState(() {
      _future = _getSearch(searchString);
    });
    return null;
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(22.0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            x = true;
                          });
                        },
                        onSubmitted: (value) {
                          searchString = value;
                          _future = _getSearch(value);
                          x = false;
                          search.clear();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Search here",
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            searchString != " "
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(
                      "Search Results for \" $searchString \".",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : SizedBox(),
            searchString != " "
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      height: 20.0,
                    ),
                  )
                : SizedBox(),
            x == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )),
                    ],
                  )
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                        future: _future,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            x = false;
                            return Container(
                              color: Colors.black.withOpacity(0.2),
                            );
                          } else {
                            return search.length.toString() == "0"
                                ? Container(
                                    color: Colors.black.withOpacity(0.2),
                                    child: Center(
                                      child: Text(
                                        "No Results Found",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                      ),
                                    ),
                                  )
                                : RefreshIndicator(
                                    key: _refreshKey,
                                    onRefresh: _refresh,
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MovieReview(
                                                                snapshot
                                                                    .data[index]
                                                                    .poster_path,
                                                                snapshot
                                                                    .data[index]
                                                                    .title,
                                                                snapshot
                                                                    .data[index]
                                                                    .overview,
                                                                snapshot
                                                                    .data[index]
                                                                    .release_date,
                                                                snapshot
                                                                    .data[index]
                                                                    .id,
                                                                snapshot
                                                                    .data[index]
                                                                    .popularity)));
                                              },
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Material(
                                                    elevation: 14,
                                                    shadowColor: Colors.white,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 150,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Stack(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 100,
                                                                  height: 150,
                                                                  //color: Colors.yellow,
                                                                  child: Image
                                                                      .network(
                                                                    snapshot.data[index].poster_path !=
                                                                            null
                                                                        ? "https://image.tmdb.org/t/p/w500" +
                                                                            snapshot.data[index].poster_path
                                                                        : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                                //),
                                                                Container(
                                                                    child: Icon(
                                                                  Icons.movie,
                                                                  color: Colors
                                                                      .amberAccent,
                                                                )),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                width: 100,
                                                                height: 150,
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .data[index]
                                                                            .title,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'fira',
                                                                            textBaseline: TextBaseline
                                                                                .alphabetic,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      child: Divider(
                                                                          thickness:2.0,
                                                                          color:
                                                                              Colors.black12),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.0,
                                                                            vertical:
                                                                                10.0),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .overview,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              3,
                                                                          style: TextStyle(
                                                                              fontFamily: 'fira',
                                                                              textBaseline: TextBaseline.alphabetic,
                                                                              color: Colors.black45,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  )),
                                            ),
                                          );
                                        }),
                                  );
                          }
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
