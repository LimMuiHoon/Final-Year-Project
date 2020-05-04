import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/tabsocmanagement.dart';
//import 'package:tracking_soc/tabsocmanagement2.dart';
//import 'package:tracking_soc/tabsocmanagement3.dart';
import 'package:tracking_soc/tabsocmanagement4.dart';
import 'package:tracking_soc/socmanagement.dart';

class MainScreenSocManagement extends StatefulWidget {
  final SocManagement socmanagement;

  const MainScreenSocManagement({Key key, this.socmanagement})
      : super(key: key);

  @override
  _MainScreenSocManagementState createState() =>
      _MainScreenSocManagementState();
}

class _MainScreenSocManagementState extends State<MainScreenSocManagement> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabSocManagement(socmanagement: widget.socmanagement),
      //TabSocManagement2(socmanagement: widget.socmanagement),
      //TabSocManagement3(socmanagement: widget.socmanagement),
      TabSocManagement4(socmanagement: widget.socmanagement),
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
            title: Text("Report"),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Add"),
          ),*/
          /*BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Report"),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
