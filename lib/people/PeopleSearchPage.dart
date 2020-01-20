import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinemaque/people/People_review.dart';
import 'package:cinemaque/model/celebs.dart';

class PeopleSearchPage extends StatefulWidget {
  @override
  _PeopleSearchPageState createState() => _PeopleSearchPageState();
}

class _PeopleSearchPageState extends State<PeopleSearchPage> {
  bool peopleBool = false;
  Future<List<People>> _future;
  List<People> peopleSearch = [];
  String searchPeopleString = " ";
  GlobalKey<RefreshIndicatorState> _refreshPeopleKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<People>> _getPeopleSearch(String s) async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/search/person?api_key=------- user you moviedb key here -----------&language=en-US&query=$s&page=1&include_adult=false");
    var jsonData1 = json.decode(data1.body);
    var u1 = Test.fromJson(jsonData1);
    peopleSearch = u1.results;
    return peopleSearch;
  }
  Future<Null> _refresh() async {
    setState(() {
      _future = _getPeopleSearch(searchPeopleString);
    });
    return null;
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
                            peopleBool = true;
                          });
                        },
                        onSubmitted: (value) {
                          searchPeopleString = value;
                          _future = _getPeopleSearch(value);
                          peopleBool = false;
                          peopleSearch.clear();
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
            searchPeopleString != " "
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(
                      "Search Results for \" $searchPeopleString \".",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : SizedBox(),
            searchPeopleString != " "
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      height: 20.0,
                      //thickness: 2.0,
                    ),
                  )
                : SizedBox(),
            peopleBool == true
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
                            peopleBool = false;
                            return Container(
                              color: Colors.black.withOpacity(0.2),
                            );
                          } else {
                            return peopleSearch.length.toString() == "0"
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
                                    key: _refreshPeopleKey,
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
                                                            PeopleReviewPage(
                                                                snapshot
                                                                    .data[index]
                                                                    .profile_path,
                                                                snapshot
                                                                    .data[index]
                                                                    .name,
                                                                snapshot
                                                                    .data[index]
                                                                    .known_for,
                                                                snapshot
                                                                    .data[index]
                                                                    .known_for_department,
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
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                width: 50,
                                                                height: 150,
                                                                //color: Colors.yellow,
                                                                child: Image
                                                                    .network(
                                                                  snapshot.data[index].profile_path !=
                                                                          null
                                                                      ? "https://image.tmdb.org/t/p/w500" +
                                                                          snapshot
                                                                              .data[index]
                                                                              .profile_path
                                                                      : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
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
                                                                    Text(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .name,
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
                                                                    Divider(
                                                                        color: Colors
                                                                            .white70),
                                                                    Text(
                                                                      snapshot.data[index].popularity.toString(),textScaleFactor: 1.2,

                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'fira',
                                                                          textBaseline: TextBaseline
                                                                              .alphabetic,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                          // }
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
