import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/tabscreenjpp.dart';
//import 'package:tracking_soc/tabscreenjpp2.dart';
import 'package:tracking_soc/tabscreenjpp3.dart';
import 'package:tracking_soc/jpp.dart';

class MainScreenJPP extends StatefulWidget {
  final JPP jpp;

  const MainScreenJPP({Key key, this.jpp}) : super(key: key);

  @override
  _MainScreenJPPState createState() => _MainScreenJPPState();
}

class _MainScreenJPPState extends State<MainScreenJPP> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreenJPP(jpp: widget.jpp),
      //TabScreenJPP2(jpp: widget.jpp),
      TabScreenJPP3(jpp: widget.jpp),
      //TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "SOC Issue Tracking System";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Issue"),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Report"),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )*/
        ],
      ),
    );
  }
}
