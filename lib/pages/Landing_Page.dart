import 'package:flutter/material.dart';
import 'package:cinemaque/components/customs_scroll_view.dart';
import 'package:cinemaque/components/drawer.dart';
import 'package:cinemaque/view/Tv_shows.dart';
import 'package:cinemaque/view/movies_page.dart';
import 'package:cinemaque/view/people.dart';
import '../movie/MovieSearchPage.dart';
import '../people/PeopleSearchPage.dart';
import '../tv/TvSearchPage.dart';

class LandingPage extends StatefulWidget {
  final String name;
  LandingPage(this.name);
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  Color primarycolor;
  TabController tabController;
  @override
  void initState() {
    super.initState();
    primarycolor = Color(0xff009933);
    tabController = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
   return Scaffold(
      drawer: DrawerExample(widget.name,primarycolor),
      appBar: AppBar(
          backgroundColor: primarycolor,
          bottom: TabBar(
            indicatorWeight: 4.0,
            indicatorColor: Colors.white,
            controller: tabController,
            isScrollable: true,
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    primarycolor = Color(0xff009933);
                    break;
                  case 1:
                    primarycolor = Color(0xffe6005c);
                    break;
                  case 2:
                    primarycolor = Color(0xff00b8e6);
                    break;
                  case 3:
                    primarycolor = Color(0xffff9900);
                    break;
                  default:
                    primarycolor = Color(0xff009933);
                }
              });
            },
            tabs: <Tab>[
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 20,
                ),
                text: "Home",
              ),
              Tab(
                icon: Icon(
                  Icons.movie,
                  size: 20,
                ),
                text: "Movies",
              ),
              Tab(
                icon: Icon(
                  Icons.live_tv,
                  size: 20,
                ),
                text: "Tv Shows",
              ),
              Tab(
                icon: Icon(
                  Icons.people,
                  size: 20,
                ),
                text: "Popular People",
              ),
            ],
          )),
      body: Scaffold(
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              FirstPage(),
              MoviePage(),
              Tvshows(),
              PeoplePage(),
            ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primarycolor,
            child: Icon(
              Icons.search,
              size: 33,
            ),
            onPressed: () {
              if (primarycolor == Color(0xff009933) || primarycolor == Color(0xffe6005c)) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MovieSearchPage()));
              } else if (primarycolor == Color(0xff00b8e6)) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TvSearchPage()));
              } else if (primarycolor == Color(0xffff9900)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PeopleSearchPage()));
              }
            }),
      ),
    );
  }
}
