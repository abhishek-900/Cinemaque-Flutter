import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cinemaque/model/celebs.dart';
import 'dart:convert';

import 'package:cinemaque/people/People_review.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}
class _PeoplePageState extends State<PeoplePage>
    with AutomaticKeepAliveClientMixin<PeoplePage> {
  @override
  bool get wantKeepAlive => true;
  Future<List<People>> _future;
  List<People> users;
  @override
  void initState() {
    super.initState();
    setState(() {
      _future = _getPeople();
    });
  }
  Future<List<People>> _getPeople() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/person/popular?api_key=------- user you moviedb key here -----------&language=en-US&page=1");
    var data2 = await http.get(
        "https://api.themoviedb.org/3/person/popular?api_key=------- user you moviedb key here -----------&language=en-US&page=2");
    var data3 = await http.get(
        "https://api.themoviedb.org/3/person/popular?api_key=------- user you moviedb key here -----------&language=en-US&page=3");
    var jsonData1 = json.decode(data1.body);
    var jsonData2 = json.decode(data2.body);
    var jsonData3 = json.decode(data3.body);
    var u1 = Test.fromJson(jsonData1);
    var u2 = Test.fromJson(jsonData2);
    var u3 = Test.fromJson(jsonData3);
    users = u1.results + u2.results + u3.results;
    return users;
  }
  Future<Null> _refresh() async {
    setState(() {
      _future = _getPeople();
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
                                    builder: (context) => PeopleReviewPage(
                                          snapshot.data[index].profile_path,
                                          snapshot.data[index].name,
                                          snapshot.data[index].known_for,
                                          snapshot
                                              .data[index].known_for_department,
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
                                    snapshot.data[index].profile_path != null
                                        ? "https://image.tmdb.org/t/p/w500" +
                                            snapshot.data[index].profile_path
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
                                            fontSize: 18,
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
