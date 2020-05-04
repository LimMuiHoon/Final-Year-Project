import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/tabscreenjabatankeselamatan.dart';
//import 'package:tracking_soc/tabscreenjabatankeselamatan2.dart';
import 'package:tracking_soc/tabscreenjabatankeselamatan3.dart';
import 'package:tracking_soc/jabatankeselamatan.dart';

class MainScreenJabatanKeselamatan extends StatefulWidget {
  final JabatanKeselamatan jabatankeselamatan;

  const MainScreenJabatanKeselamatan({Key key, this.jabatankeselamatan})
      : super(key: key);

  @override
  _MainScreenJabatanKeselamatanState createState() =>
      _MainScreenJabatanKeselamatanState();
}

class _MainScreenJabatanKeselamatanState
    extends State<MainScreenJabatanKeselamatan> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreenJabatanKeselamatan(
          jabatankeselamatan: widget.jabatankeselamatan),
      /*TabScreenJabatanKeselamatan2(
          jabatankeselamatan: widget.jabatankeselamatan),*/
      TabScreenJabatanKeselamatan3(
          jabatankeselamatan: widget.jabatankeselamatan),
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
