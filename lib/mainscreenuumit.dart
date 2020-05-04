import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/tabscreenuumit.dart';
//import 'package:tracking_soc/tabscreenuumit2.dart';
import 'package:tracking_soc/tabscreenuumit3.dart';
import 'package:tracking_soc/uumit.dart';

class MainScreenUUMIT extends StatefulWidget {
  final UUMIT uumit;

  const MainScreenUUMIT({Key key, this.uumit}) : super(key: key);

  @override
  _MainScreenUUMITState createState() => _MainScreenUUMITState();
}

class _MainScreenUUMITState extends State<MainScreenUUMIT> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreenUUMIT(uumit: widget.uumit),
      //TabScreenUUMIT2(uumit: widget.uumit),
      TabScreenUUMIT3(uumit: widget.uumit),
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
