import 'package:cinemaque/login/Connection.dart';
import 'package:cinemaque/login/auth.dart';
import 'package:cinemaque/view/Tv_shows.dart';
import 'package:cinemaque/view/movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinemaque/view/people.dart';

import '../constants.dart';

class DrawerExample extends StatefulWidget {
  final String eMail;
  final Color colors;
  DrawerExample(this.eMail, this.colors);
  @override
  _DrawerExampleState createState() => _DrawerExampleState();
}
class _DrawerExampleState extends State<DrawerExample> {
  AssetImage myImage;
  AuthPage lPg = AuthPage();
  @override
  void initState() {
    super.initState();
    myImage = AssetImage("images/movie.jpg");
    noColor = Color(0xffe6e6e6);
    noText = TextStyle(color: Colors.black);
    yesText = TextStyle(color: Colors.white);
    yesColor = Color(0xffff0000);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage, context);
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
    String name = widget.eMail.substring(0, widget.eMail.indexOf("@"));
    return Drawer(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountEmail: widget.eMail != null ? Text(widget.eMail, style: TextStyle(fontSize: 20),) : Text(" "),
              accountName: widget.eMail != null ? Text(name.toUpperCase()) : Text(" USER "),
              currentAccountPicture: CircleAvatar(
                minRadius: 15,
                maxRadius: 25,
                child: Image.asset('images/logo_1.png'),
              ),
            decoration: BoxDecoration(
              color: widget.colors,
             //image: DecorationImage(image: myImage, fit: BoxFit.cover)
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MoviePage()));
            },
            trailing: Icon(Icons.local_movies),
            title: Text(
              "Movies",
              style: TextStyle(fontSize: 23),
            ),
          ),
          drawerDivs,
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Tvshows ()));
            },
            trailing: Icon(Icons.live_tv),
            title: Text(
              "TV Shows",
              style: TextStyle(fontSize: 23),
            ),
          ),
          drawerDivs,
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PeoplePage()));
            },
            trailing: Icon(Icons.person),
            title: Text(
              "Popular People",
              style: TextStyle(fontSize: 23),
            ),
          ),
          drawerDivs,
          ListTile(
            onTap: () {},
            trailing: Icon(Icons.info_outline),
            title: Text(
              "About us",
              style: TextStyle(fontSize: 23),
            ),
          ),
          drawerDivs,
          ListTile(
            trailing: Icon(Icons.power_settings_new),
            onTap: () {
              UserModel().logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AuthPage()));
            },
            title: Text(
              "Sign Out",
              style: TextStyle(fontSize: 23),
            ),
          ),
          drawerDivs,
          ListTile(
            trailing: Icon(Icons.close),
            onTap: () {
              createAlertDialog(context);
            },
            title: Text(
              "Close",
              style: TextStyle(fontSize: 23),
            ),
          )
        ],
      ),
    );
  }
}
