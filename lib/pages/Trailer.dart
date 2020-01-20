import 'package:flutter/material.dart';
import 'package:cinemaque/pages/video_trailer.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Trailer extends StatefulWidget {
  final int id;
  Trailer(this.id);
  @override
  _TrailerState createState() => _TrailerState();
}

class _TrailerState extends State<Trailer> {
  FlutterWebviewPlugin webview=FlutterWebviewPlugin();
  List<Youtube> tube = [];
  Future<List<Youtube>> _future;
  Future<List<Youtube>> _video() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/movie/${widget.id}?api_key=------- user you moviedb key here -----------&append_to_response=videos");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['videos']['results'];
    for (var u in info1) {
      Youtube v = Youtube(u["key"]);
      tube.add(v);
    }
    return tube;
  }
  @override
  void initState() {
    super.initState();
    _future = _video();
    webview.close();
  }
  @override
  void dispose() {
    webview.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {

                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.length == 0) {
                  return Center(
                      child: Text(
                    "No video Available",
                    style: TextStyle(fontSize: 25),
                  ));
                } else {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return WebviewScaffold(
                          url: "https://www.youtube.com/watch?v=" +
                              snapshot.data[index].key,
                          withLocalStorage: true,
                          withJavascript: true,
                        );
                      });
                }
              })),
    );
  }
}
