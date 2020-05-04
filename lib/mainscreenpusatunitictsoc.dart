import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/tabscreenpusatunitictsoc.dart';
//import 'package:tracking_soc/tabscreenpusatunitictsoc2.dart';
import 'package:tracking_soc/tabscreenpusatunitictsoc3.dart';
import 'package:tracking_soc/pusatunitictsoc.dart';

class MainScreenPusatUnitICTSOC extends StatefulWidget {
  final PusatUnitICTSOC pusatunitictsoc;

  const MainScreenPusatUnitICTSOC({Key key, this.pusatunitictsoc})
      : super(key: key);

  @override
  _MainScreenPusatUnitICTSOCState createState() =>
      _MainScreenPusatUnitICTSOCState();
}

class _MainScreenPusatUnitICTSOCState extends State<MainScreenPusatUnitICTSOC> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreenPusatUnitICTSOC(pusatunitictsoc: widget.pusatunitictsoc),
      //TabScreenPusatUnitICTSOC2(pusatunitictsoc: widget.pusatunitictsoc),
      TabScreenPusatUnitICTSOC3(pusatunitictsoc: widget.pusatunitictsoc),
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
