import 'package:flutter/material.dart';
import 'package:cinemaque/pages/Trailer.dart';
import 'package:cinemaque/model/Tv.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../model/cast_detail.dart';

class TvReviewPage extends StatefulWidget {
  final String name;
  final String overview;
  final String backdrop_path;
  final String poster_path;
  final String first_air_date;
  final int id;
  final double popularity;
  TvReviewPage(this.name, this.overview, this.backdrop_path, this.poster_path,
      this.first_air_date, this.id,
      {this.popularity});
  @override
  _TvReviewPageState createState() => _TvReviewPageState();
}

class _TvReviewPageState extends State<TvReviewPage>
    with AutomaticKeepAliveClientMixin<TvReviewPage> {
  Icon ic,ic1;
  bool pressed = false;
  @override
  bool get wantKeepAlive => true;
  Future<List<TvAttributes>> _future;
  Future<List<CastDetail>> _future2;
  List<CastDetail> ca = [];
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    ic = Icon(Icons.favorite_border,color: Colors.white,size: 40);
    ic1=Icon(Icons.favorite_border,color: Colors.white,size: 20);
    setState(() {
      _future = _tvVideo();
      _future2 = _cast();
    });
  }
  List<TvAttributes> tvv = [];
  Future<List<CastDetail>> _cast() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/${widget.id}/credits?api_key=------- user you moviedb key here -----------&language=en-US");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['cast'];
    for (var u in info1) {
      CastDetail v = CastDetail(u["character"], u["name"], u["profile_path"]);
      ca.add(v);
    }
    return ca;
  }
  Future<List<TvAttributes>> _tvVideo() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/${widget.id}/similar?api_key=------- user you moviedb key here -----------&language=en-US&page=1");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['results'];
    for (var u in info1) {
      TvAttributes t = TvAttributes(u["name"], u["overview"], u["backdrop_path"], u["poster_path"],
          u["first_air_date"], u['id'], popularity: u["popularity"]);
      tvv.add(t);
    }
    return tvv;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
     double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xff262626),
      body: ListView(
        children: <Widget>[
          Container(
            height: 570,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: Mclipper(),
                  child: Container(
                    height: 510,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 10.0),
                          blurRadius: 10.0)
                    ]),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'pic',
                          child: Image.network(
                            widget.poster_path != null
                                ? "https://image.tmdb.org/t/p/w500" +
                                    widget.poster_path
                                : "https://www.dmataxaccounting.com/wp-content/uploads/2016/11/Dark-Grey-Background-Best-Wallpaper-Gallery-dji6x-Free.jpg",
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                const Color(0x00000000),
                                const Color(0xD9333333),
                              ],
                                  stops: [
                                0.0,
                                0.9
                              ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(0.0, 1.0))),
                          child: Padding(
                            padding: EdgeInsets.only(top: 120, left: 95),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 35.0),
                                ),
                                Text(
                                  widget.first_air_date,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top:10,
                  right: 30,
                  child: IconButton(icon: ic,
                    onPressed: (){
                      if(pressed==false)
                      {
                        setState(() {
                          pressed = true;
                          ic = Icon(Icons.favorite,color: Colors.red,size: 40);
                          ic1=Icon(Icons.favorite,color: Colors.red,size: 20);
                          _scaffoldkey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Marked as Favourite!",
                              style: TextStyle(fontSize: 20),
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ));
                        });
                      }
                      else
                      {
                        setState(() {
                          pressed = false;
                          ic = Icon(Icons.favorite_border,color: Colors.white,size: 40);
                          ic1=Icon(Icons.favorite_border,color: Colors.white,size: 20);
                          _scaffoldkey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Unmarked from Favourites!",
                              style: TextStyle(fontSize: 20),
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.red,
                          ));
                        });
                      }
                    }, ),
                ),
                Positioned(
                  top: 520,
                  right: 30.0,
                  child: FractionalTranslation(
                    translation: Offset(0.0, -0.8),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: RaisedButton(
                              color: Colors.red,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                child: Text(
                                  "Watch Trailer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Trailer(widget.id)));
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: paddingVariable,
                child: Container(
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                    )),
              ),
              Padding(
                padding: paddingVariable,
                child: Container(
                  child: Text(
                    "Release Date ",
                    style: TextStyle(
                        fontSize: 25,
                        wordSpacing: 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: Colors.white,
              indent: 2,
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 30, left: 20),
                child: Container(
                  height: 120,
                  width: 170,
                  child: Image.network(
                    widget.backdrop_path != null
                        ? "https://image.tmdb.org/t/p/w500" +
                        widget.backdrop_path
                        : "https://www.dmataxaccounting.com/wp-content/uploads/2016/11/Dark-Grey-Background-Best-Wallpaper-Gallery-dji6x-Free.jpg",
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child:Row(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(right: 15, left: 15),
                              child:ic1),
                          Container(
                            child: Text(
                              pressed? 'Favourite':'  - - - - - - - - -  ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )),
                          ),
                          Container(
                            child: Text(
                              widget.first_air_date,
                              style: TextStyle(
                                  fontSize: 15,
                                  wordSpacing: 6,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Icon(Icons.person_outline, color: Colors.green),
                        ),
                        Container(
                          child: Text(
                            widget.popularity.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                wordSpacing: 6,
                                color: Colors.white),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          sizedBox,
          Padding(
            padding: paddingVariable,
            child: Container(
              child: Text(
                "Cast ",
                style: TextStyle(
                    fontSize: 25,
                    wordSpacing: 6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: Colors.white,
              indent: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
                height: 170,
                width: screenwidth,
                child: FutureBuilder(
                    future: _future2,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                            child: Center(
                                child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )));
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  //statement
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: 154,
                                        height: 168,
                                        child: Image.network(
                                          snapshot.data[index].profile_path !=
                                                  null
                                              ? "https://image.tmdb.org/t/p/w500" +
                                                  snapshot
                                                      .data[index].profile_path
                                              : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        bottom: 0,
                                        child: Container(
                                          width: 200,
                                          color: Colors.black.withOpacity(0.5),
                                          child: Text(
                                            snapshot.data[index].name,
                                            style: TextStyle(
                                                fontFamily: 'fira',
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })),
          ),
          sizedBox,
          Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
            child: Container(
                height: 30,
                width: 60,
                child: Text("Description:-",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'fira',
                      fontWeight: FontWeight.bold,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: Colors.white,
              indent: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(
              widget.overview,
              style: TextStyle(
                  fontFamily: 'Exo',
                  fontSize: 22,
                  wordSpacing: 6,
                  color: Colors.white),
            ),
          ),
          sizedBox,
          Padding(
            padding: paddingVariable,
            child: Container(
              child: Text(
                "Similar Shows",
                style: TextStyle(
                    fontSize: 25,
                    wordSpacing: 6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: Colors.white,
              indent: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
                height: 170,
                width: screenwidth,
                child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                            child: Center(
                                child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )));
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TvReviewPage(
                                              snapshot.data[index].name,
                                              snapshot.data[index].overview,
                                              snapshot
                                                  .data[index].backdrop_path,
                                              snapshot.data[index].poster_path,
                                              snapshot
                                                  .data[index].first_air_date,
                                              snapshot.data[index].id,
                                          popularity: snapshot.data[index].popularity,)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: 154,
                                        height: 168,
                                        child: Image.network(
                                          snapshot.data[index].poster_path !=
                                                  null
                                              ? "https://image.tmdb.org/t/p/w500" +
                                                  snapshot
                                                      .data[index].poster_path
                                              : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        bottom: 0,
                                        child: Container(
                                          width: 200,
                                          color: Colors.black.withOpacity(0.5),
                                          child: Text(
                                            snapshot.data[index].name,
                                            style: TextStyle(
                                                fontFamily: 'fira',
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 15),
                child: Icon(Icons.person_outline,size: 30, color: Colors.lightGreen),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:paddingVariable,
                  child: Container(
                    child: Text(
                      "Popularity ",
                      style: TextStyle(
                          fontSize: 25,
                          wordSpacing: 6,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50, bottom: 5, left: 15),
                child: Container(
                  child: Text(
                    widget.popularity.toString(),
                    style: TextStyle(
                        fontSize: 25,
                        wordSpacing: 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 100);
    var controlpoint = Offset(35.0, size.height);
    var endpoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
