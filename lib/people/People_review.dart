import 'package:cinemaque/model/celebs.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PeopleReviewPage extends StatefulWidget {
  final List<KnownFor> knownFor;
  final String profile_path;
  final String name;
  final String known_for_department;
  final double popularity;
  PeopleReviewPage(this.profile_path, this.name, this.knownFor,
      this.known_for_department, this.popularity);
  @override
  _PeopleReviewPageState createState() => _PeopleReviewPageState(this.knownFor);
}

class _PeopleReviewPageState extends State<PeopleReviewPage>
    with AutomaticKeepAliveClientMixin<PeopleReviewPage> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  Icon ic;
  bool pressed = false;
  List<KnownFor> knownFor;
  _PeopleReviewPageState(this.knownFor);
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    ic = Icon(Icons.favorite_border,color: Colors.white,size: 40);

    setState(() {});
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
                            widget.profile_path != null
                                ? "https://image.tmdb.org/t/p/w500" +
                                    widget.profile_path
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
                            padding: EdgeInsets.only(top: 350, left: 110),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 35.0),
                                ),
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: paddingVariable,
            child: Container(
              child: Text(
                "Department of Work ",
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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 30, left: 15),
                child: Container(
                    child: Icon(
                  Icons.star,
                  color: Colors.amber,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 30, left: 15),
                child: Container(
                  child: Text(
                    widget.known_for_department,
                    style: TextStyle(
                        fontSize: 25,
                        wordSpacing: 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: paddingVariable,
            child: Container(
              child: Text(
                "Known For ",
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
          /* SizedBox(
            height: 15,
          ),*/
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
                height: 350,
                width: screenwidth,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: knownFor.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 40, left: 10, right: 10),
                      child: Container(
                        width: screenwidth,
                        height: 340,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22.2),
                                child: Container(
                                  height: 240,
                                  width: 190,
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        knownFor[index].poster_path != null
                                            ? "https://image.tmdb.org/t/p/w500" +
                                                knownFor[index].poster_path
                                            : "http://www.ropeworksgear.com/site/skin/img/no-image.jpg",
                                        fit: BoxFit.fill,
                                      ),
                                      knownFor[index].title != null
                                          ? Positioned(
                                              top: 160,
                                              bottom: 0,
                                              child: Container(
                                                //height: 30,
                                                width: 160,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: Center(
                                                    child: Text(
                                                      knownFor[index].title !=
                                                              null
                                                          ? knownFor[index]
                                                              .title
                                                          : "",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(knownFor[index].overview,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
          sizedBox,
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
                  padding: paddingVariable,
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
            height: 20,
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
