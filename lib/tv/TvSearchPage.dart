import 'package:cinemaque/tv/tv_review_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/Tv.dart';

class TvSearchPage extends StatefulWidget {
  @override
  _TvSearchPageState createState() => _TvSearchPageState();
}

class _TvSearchPageState extends State<TvSearchPage> {
  bool tvBool = false;
  Future<List<TvAttributes>> _future;
  List<TvAttributes> tvSearch = [];
  String searchTvString = " ";
  GlobalKey<RefreshIndicatorState> _tvRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  Future<List<TvAttributes>> _getTvSearch(String s) async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/search/tv?api_key=------- user you moviedb key here -----------&language=en-US&query=$s&page=1");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1["results"];
    for (var u in info1) {
      TvAttributes v = TvAttributes(u["name"], u["overview"],
          u["backdrop_path"], u["poster_path"], u["first_air_date"], u["id"]);
      tvSearch.add(v);
    }
    return tvSearch;
  }

  Future<Null> _refresh() async {
    setState(() {

      _future = _getTvSearch(searchTvString);
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
      backgroundColor: Colors.black.withOpacity(0.2),
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
                          tvBool = true;
                        });
                      },
                      onSubmitted: (value) {
                        searchTvString = value;
                        _future = _getTvSearch(value);
                        tvBool = false;
                        tvSearch.clear();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " search Tv here",
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
          searchTvString != " "
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Text(
                    "Search Results for \" $searchTvString \".",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontStyle: FontStyle.italic),
                  ),
                )
              : SizedBox(),
          searchTvString != " "
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: Colors.white,
                    height: 20.0,
                    //thickness: 2.0,
                  ),
                )
              : SizedBox(),
          tvBool == true
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          tvBool = false;
                          return Container(
                            color: Colors.black.withOpacity(0.2),
                          );
                        } else {
                          return tvSearch.length.toString() == "0"
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
                                  key: _tvRefreshKey,
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
                                                          TvReviewPage(
                                                              snapshot
                                                                  .data[index]
                                                                  .name,
                                                              snapshot
                                                                  .data[index]
                                                                  .overview,
                                                              snapshot
                                                                  .data[index]
                                                                  .backdrop_path,
                                                              snapshot
                                                                  .data[index]
                                                                  .poster_path,
                                                              snapshot
                                                                  .data[index]
                                                                  .first_air_date,
                                                              snapshot
                                                                  .data[index]
                                                                  .id)));
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
                                                        children: <Widget>[
                                                          Container(
                                                            width: 100,
                                                            height: 150,
                                                            child:
                                                                Image.network(
                                                              snapshot
                                                                          .data[
                                                                              index]
                                                                          .poster_path !=
                                                                      null
                                                                  ? "https://image.tmdb.org/t/p/w500" +
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .poster_path
                                                                  : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
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
                                                          color: Colors.white,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .name,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'fira',
                                                                      textBaseline:
                                                                          TextBaseline
                                                                              .alphabetic,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                  child: Divider(
                                                                      thickness:
                                                                          2.0,
                                                                      color: Colors
                                                                          .black12)),
                                                              Flexible(
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          10.0),
                                                                  child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .overview,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'fira',
                                                                        textBaseline:
                                                                            TextBaseline
                                                                                .alphabetic,
                                                                        color: Colors
                                                                            .black45,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                        }
                      }),
                ),
        ],
      )),
    );
  }
}
