import 'dart:async';
import 'package:cinemaque/login/Connection.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _connectionStatus = "unknown";
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult res) {
      _connectionStatus = res.toString();
     /* print(_connectionStatus);*/
      if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
        Timer(Duration(seconds: 3), () {
          UserModel().autoAuthenticate(context);
        });
      } else {
        Timer(Duration(seconds: 3), () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 10.0,
                  title: Text("Loss Connection"),
                  content: Text("Check your Internet Connectivity !"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      child: Image.asset('images/logo_1.png',)
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text('CINEMAQUE',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontFamily: 'SairaStencilOne-Regular')),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.blueAccent),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text('Loading....',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
