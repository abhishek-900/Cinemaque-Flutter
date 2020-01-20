import 'package:flutter/material.dart';
import 'package:cinemaque/pages/video_trailer.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TvTrailer extends StatefulWidget {
  final int id;
  TvTrailer(this.id);
  @override
  _TvTrailerState createState() => _TvTrailerState();
}

class _TvTrailerState extends State<TvTrailer> {
  List<Youtube> tvtube = [];
  FlutterYoutube youtube;
  Future<List<Youtube>> _video() async {
    var data1 = await http.get(
        "https://api.themoviedb.org/3/tv/${widget.id}?api_key=------- user you moviedb key here -----------&append_to_response=videos");
    var jsonData1 = json.decode(data1.body);
    var info1 = jsonData1['videos']['results'];
    for (var u in info1) {
      Youtube v = Youtube(u["key"]);
      tvtube.add(v);
    }
    return tvtube;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Container(
            child: FutureBuilder(
                future: _video(),
                builder: (context, snapshot) {

                  if (snapshot.data == null) {
                    return Center(child: Text("No video Available",style: TextStyle(fontSize: 25),));
                  }
                  else if(snapshot.data.length==0){
                    return Center(child: Text("No video Available",style: TextStyle(fontSize: 25),));
                  }
                  else {
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Center(
                                child: snapshot.data[index].key!=null?FlutterYoutube.playYoutubeVideoByUrl(
                                    apiKey:
                                    "------- user you youtube key here -----------",
                                    videoUrl:
                                    "https://www.youtube.com/watch?v=" +
                                        snapshot.data[index].key,
                                    fullScreen: true):Text("No video Available",style: TextStyle(fontSize: 25),)
                            ),
                          );
                        });
                  }
                })),
      ),
    );
  }
}
