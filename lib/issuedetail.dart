import 'dart:async';
//import 'dart:io';
//import 'dart:math';
//import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tracking_soc/socmanagement.dart';
import 'package:tracking_soc/jpp.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_soc/staff.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tracking_soc/issue.dart';
import 'mainscreen.dart';
//import 'newissue.dart';
import 'package:tracking_soc/newissue.dart';
//import 'package:image_picker/image_picker.dart';

//import 'package:toast/toast.dart';
//import 'package:flutter/src/widget/text.dart';
double perpage = 1;
String urledit = "http://limmuihoon.com/trackingsoc/php/edit_issue_desc.php";
String urldelete = "http://limmuihoon.com/trackingsoc/php/delete_issue.php";
String urlupdatetitle =
    "http://limmuihoon.com/trackingsoc/php/edit_issue_title.php";
String urlupdatecategory =
    "http://limmuihoon.com/trackingsoc/php/edit_issue_category.php";
String urluploadImage =
    "http://limmuihoon.com/trackingsoc/php/upload_imageissue.php";
//File _image;
int number = 0;
//String _value;

class IssueDetail extends StatefulWidget {
  final Issue issue;
  final Staff staff;
  final SocManagement socmanagement;
  final JPP jpp;
  const IssueDetail({
    Key key,
    this.issue,
    this.staff,
    this.socmanagement,
    this.jpp,
    //SocManagement socmanagement,
    // String barterid,
    // String bartertitle,
    // String barterowner,
    // String barterdes,
    // String barterprice,
    // String bartertime,
    // String barterimage,
    // barterworker,
    // String barterlat,
    // String barterlon,
    // String barterrating
  }) : super(key: key);

  @override
  _IssueDetailState createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetail> {
  List data;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ISSUE DETAILS'),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                issue: widget.issue,
                staff: widget.staff,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            staff: widget.staff,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Issue issue;
  final Staff staff;
  DetailInterface({this.issue, this.staff});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  //Completer<GoogleMapController> _controller = Completer();
  //CameraPosition _myLocation;
  List data;
  List<DropdownMenuItem<String>> listCategory = [];
  List<String> category = [
    "JPP",
    "Security Department",
    "SOC ICT Unit",
    "UUMIT"
  ];
  String currentCategory = 'JPP';

  List<DropdownMenuItem<String>> listTitle = [];
  List<String> title = [
    "Damage/Cleanliness",
    "DKG/Seminar Hall",
    "SOC Lab Damage",
    "System/ Internet"
  ];
  String currentTitle = 'Damage/Cleanliness';

  void loadData() {
    listCategory = [];
    listCategory = category
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();

    listTitle = [];
    listTitle = title
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    /*_myLocation = CameraPosition(
      target: LatLng(double.parse(widget.barter.barterlat),
          double.parse(widget.barter.barterlon)),
      zoom: 17,
    );
    print(_myLocation.toString());*/
  }

  @override
  Widget build(BuildContext context) {
    //var index;
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://limmuihoon.com/trackingsoc/images/${widget.issue.issueimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.issue.issuetitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.issue.issuetime),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Issue Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.issue.issuedes),
                ]),
                TableRow(children: [
                  Text("Issue Category",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.issue.issuecategory),
                ]),
                TableRow(children: [
                  Text("Issue Status",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.issue.issuestatus),
                ]),
                TableRow(children: [
                  Text("Issue Task Comment",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.issue.issuetaskcomment),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              /* Container(
                    height: 120,
                    width: 340,
                    child: GoogleMap(
                      // 2
                      initialCameraPosition: _myLocation,
                      // 3
                      mapType: MapType.normal,
                      // 4
    
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),*/
              /*Container(
                    width: 350,
                    child: InkWell(
                      onLongPress: () => _onIssueDelete(
                        data[index]['issueid'].toString(),
                        data[index]['issuetitle'].toString(),
                      ),
                    ),
                    //MapSample(),
                  ),*/
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'EDIT ISSUE TITLE',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onEditTitle,
                ),
                //MapSample(),
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'EDIT ISSUE CATEGORY',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onEditCategory,
                ),
                //MapSample(),
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'EDIT ISSUE DESCRIPTION',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onEdit,
                ),
                //MapSample(),
              ),
              /*Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'EDIT ISSUE PICTURE',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onEditPicture,
                ),
                //MapSample(),
              ),*/
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'DELETE ISSUE',
                    style: TextStyle(fontSize: 16),
                  ),
                  /*InkWell(onLongPress: _onDelete(
                                                                                                data[index]['issueid'].toString(),
                                                                                                data[index]['issuetitle'].toString()
                                                                                              ),),*/
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onIssueDelete,
                ),
              )
              //MapSample(),
              /*Container(
                                                                                                            margin: EdgeInsets.all(12),
                                                                                                            height: 50.0,
                                                                                                            width: 100.0,
                                                                                                            decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                                                                                                              BoxShadow(
                                                                                                                  color: Colors.grey, blurRadius: 4, offset: Offset(0, 2))
                                                                                                            ]),
                                                                                                            child: Material(
                                                                                                              child: InkWell(
                                                                                                                child: Center(
                                                                                                                    child: Text("DELETE",
                                                                                                                        style: Theme.of(context).textTheme.body1)),
                                                                                                                //onTap: () {},
                                                                                                                onLongPress: () => _onIssueDelete(
                                                                                                                  data[index]['issueid'].toString(),
                                                                                                                  data[index]['issuetitle'].toString(),
                                                                                                                  data[index]['issueowneremail'],
                                                                                                                  data[index]['issueownername'],
                                                                                                                  data[index]['issuedesc'],
                                                                                                                  data[index]['issuetime'],
                                                                                                                  data[index]['issueimage'],
                                                                                                                  data[index]['issuecategory'],
                                                                                                                  data[index]['issuestatus'],
                                                                                                                  data[index]['issuetaskcomment'],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          )*/
            ],
          ),
        ),
      ],
    );
  }

  void _onEdit() {
    TextEditingController editController = TextEditingController();
    //flutter defined function
    print(widget.issue.issuestatus);
    if (widget.issue.issuestatus == "Progress" ||
        widget.issue.issuestatus == "Finish") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Issue Description"),
          content: new TextField(
              controller: editController,
              decoration: InputDecoration(
                labelText: 'Issue Description',
                //icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (editController.text.length < 5) {
                  Toast.show(
                      "Issue Desciption should be more than 5 characters long",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urledit, body: {
                  "issueid": widget.issue.issueid,
                  "issueedit": editController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.issue.issuedes = dres[12];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.issue.issuedes = dres[12];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*void _onIssueDelete(
                                                                                                  String issueid,
                                                                                                  String issuetitle,
                                                                                                  String issueowneremail,
                                                                                                  String issueownername,
                                                                                                  String issuedesc,
                                                                                                  String issuetime,
                                                                                                  String issueimage,
                                                                                                  String issuecategory,
                                                                                                  String issuestatus,
                                                                                                  String issuetaskcomment) {
                                                                                                //String issueid;
                                                                                                //String issuename;
                                                                                                print("Delete" + issueid);
                                                                                                _showDialog(issueid, issuetitle, issueowneremail, issueownername, issuedesc,
                                                                                                    issuetime, issueimage, issuecategory, issuestatus, issuetaskcomment);
                                                                                              }
                                                                                            }*/

  /*void _showDialog(
                                                                                                String issueid,
                                                                                                String issuetitle,
                                                                                                String issueowneremail,
                                                                                                String issueownername,
                                                                                                String issuedesc,
                                                                                                String issuetime,
                                                                                                String issueimage,
                                                                                                String issuecategory,
                                                                                                String issuestatus,
                                                                                                String issuetaskcomment) {
                                                                                              // flutter defined function
                                                                                              var context;
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  // return object of type Dialog
                                                                                                  return AlertDialog(
                                                                                                    title: new Text("Delete" + issueid),
                                                                                                    content: new Text("Are your sure?"),
                                                                                                    actions: <Widget>[
                                                                                                      // usually buttons at the bottom of the dialog
                                                                                                      new FlatButton(
                                                                                                        child: new Text("Yes"),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                          deleteRequest(issueid);
                                                                                                        },
                                                                                                      ),
                                                                                                      new FlatButton(
                                                                                                        child: new Text("No"),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }*/

  /*Future<String> deleteRequest(String issueid) async {
                                                                                              String urlLoadIssue =
                                                                                                  "http://limmuihoon.com/trackingsoc/php/delete_issue.php";
                                                                                              BuildContext context;
                                                                                              ProgressDialog pr = new ProgressDialog(context,
                                                                                                  type: ProgressDialogType.Normal, isDismissible: false);
                                                                                              pr.style(message: "Deleting Issue");
                                                                                              pr.show();
                                                                                              http.post(urlLoadIssue, body: {
                                                                                                issueid: issueid,
                                                                                              }).then((res) {
                                                                                                print(res.body);
                                                                                                if (res.body == "success") {
                                                                                                  Toast.show("Success", context,
                                                                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                  init();
                                                                                                } else {
                                                                                                  Toast.show("Failed", context,
                                                                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                }
                                                                                              }).catchError((err) {
                                                                                                print(err);
                                                                                                pr.dismiss();
                                                                                              });
                                                                                            }*/

  void init() {}
  /*void _onAcceptBarter() {
                                                                                              var widget;
                                                                                              if (widget.staff.email == "user@noregister") {
                                                                                                BuildContext context;
                                                                                                Toast.show("Please register to view accept barter", context,
                                                                                                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                return;
                                                                                              } else {
                                                                                                _showDialog();
                                                                                              }
                                                                                              print("Accept Barter");
                                                                                            }*/

  //void _showDialog() {
  // flutter defined function
  /*var widget;
                                                                                              if (int.parse(widget.user.credit) < 1) {
                                                                                                BuildContext context;
                                                                                                Toast.show("Credit not enough ", context,
                                                                                                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                return;
                                                                                              }*/
  /*var context;
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  // return object of type Dialog
                                                                                                  var widget;
                                                                                                  return AlertDialog(
                                                                                                    title: new Text("Accept " + widget.issue.issuetitle),
                                                                                                    content: new Text("Are your sure?"),
                                                                                                    actions: <Widget>[
                                                                                                      // usually buttons at the bottom of the dialog
                                                                                                      new FlatButton(
                                                                                                        child: new Text("Yes"),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                          acceptRequest();
                                                                                                        },
                                                                                                      ),
                                                                                                      new FlatButton(
                                                                                                        child: new Text("No"),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }*/

  /*Future<String> acceptRequest() async {
                                                                                              String urlAcceptBarter =
                                                                                                  "https://limmuihoon.com/trackingsoc/php/accept_issue.php";
                                                                                              BuildContext context;
                                                                                              ProgressDialog pr = new ProgressDialog(context,
                                                                                                  type: ProgressDialogType.Normal, isDismissible: false);
                                                                                              pr.style(message: "Accepting Barter");
                                                                                              pr.show();
                                                                                              var widget;
                                                                                              http.post(urlAcceptBarter, body: {
                                                                                                "issueid": widget.issue.issueid,
                                                                                                "email": widget.staff.email,
                                                                                                // "credit": widget.user.credit,
                                                                                              }).then((res) {
                                                                                                print(res.body);
                                                                                                if (res.body == "success") {
                                                                                                  Toast.show("Success", context,
                                                                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                  pr.dismiss();
                                                                                                  _onLogin(widget.user.email, context);
                                                                                                } else {
                                                                                                  Toast.show("Failed", context,
                                                                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                  pr.dismiss();
                                                                                                }
                                                                                              }).catchError((err) {
                                                                                                print(err);
                                                                                                pr.dismiss();
                                                                                              });
                                                                                              return null;
                                                                                            }*/

  /*void _onLogin(String email, BuildContext ctx) {
                                                                                              String urlgetuser = "https://limmuihoon.com/trackingsoc/php/get_staffjpp.php";
                                                                                            
                                                                                              http.post(urlgetuser, body: {
                                                                                                "email": email,
                                                                                              }).then((res) {
                                                                                                print(res.statusCode);
                                                                                                var string = res.body;
                                                                                                List dres = string.split(",");
                                                                                                print(dres);
                                                                                                if (dres[0] == "success") {
                                                                                                  Staff staff = new Staff(
                                                                                                    name: dres[1],
                                                                                                    email: dres[2],
                                                                                                    phone: dres[3],
                                                                                                    position: dres[4],
                                                                                                  );
                                                                                            
                                                                                                  Navigator.push(ctx,
                                                                                                      MaterialPageRoute(builder: (context) => MainScreen(staff: staff)));
                                                                                                }
                                                                                              }).catchError((err) {
                                                                                                print(err);
                                                                                              });
                                                                                            }*/

  void _onIssueDelete() {
    print("Delete");
    print(widget.issue.issuestatus);
    if (widget.issue.issuestatus == "Progress") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    //TextEditingController editController = TextEditingController();
    //flutter defined function
    /*print(widget.user.name);
                                                                                                if (widget.user.name == "not register") {
                                                                                                  Toast.show("Not allowed", context,
                                                                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                                                  return;
                                                                                                }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete the Issue?"),
          content: new Text("Are You Sure?"),
          /*content: new TextField(
                                                                                      controller: editController,
                                                                                      decoration: InputDecoration(
                                                                                        labelText: 'Issue Description',
                                                                                        //icon: Icon(Icons.person),
                                                                                      )),*/
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                /*if (editController.text.length < 5) {
                                                                                          Toast.show(
                                                                                              "Issue Desciption should be more than 5 characters long",
                                                                                              context,
                                                                                              duration: Toast.LENGTH_LONG,
                                                                                              gravity: Toast.BOTTOM);
                                                                                          return;
                                                                                        }*/
                ProgressDialog pr = new ProgressDialog(context,
                    type: ProgressDialogType.Normal, isDismissible: false);
                pr.style();
                http.post(urldelete, body: {
                  "issueid": widget.issue.issueid,
                  "issuetitle": widget.issue.issuetitle,
                  "issueowneremail": widget.issue.issueowneremail,
                  "issueownername": widget.issue.issueownername,
                  "issuedesc": widget.issue.issuedes,
                  "issuetime": widget.issue.issuetime,
                  "issueimage": widget.issue.issueimage,
                  "issuecategory": widget.issue.issuecategory,
                  "issuestatus": widget.issue.issuestatus,
                  "isusetaskcomment": widget.issue.issuetaskcomment
                  //"issueedit": editController.text,
                }).then((res) {
                  /*var string = res.body;
                                                                                          List dres = string.split(",");
                                                                                          if (dres[0] == "success") {
                                                                                            print('in success');
                                                                                            setState(() {
                                                                                              widget.issue.issuedes = dres[12];
                                                                                              if (dres[0] == "success") {
                                                                                                print("in setstate");
                                                                                                widget.issue.issuedes = dres[12];
                                                                                              }
                                                                                            });
                                                                                          }*/
                  print(res.body);
                  if (res.body == "success") {
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                  pr.dismiss();
                });
                //return null;
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onEditTitle() {
    //print("Delete");
    print(widget.issue.issuestatus);
    if (widget.issue.issuestatus == "Progress" ||
        widget.issue.issuestatus == "Finish") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    //String issue;
    //TextEditingController statusController = TextEditingController();
    // flutter defined function
    //print(widget.jpp.name);
    /*if (widget.jpp.name == "not register") {
                                          Toast.show("Not allowed", context,
                                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                          return;
                                        }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Change Issue Status"),
          /*content: new TextField(
                                                  controller: statusController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Status',
                                                    //icon: Icon(Icons.person),
                                                  )),*/

          title: Container(
            child: FormField(builder: (FormFieldState state) {
              return InputDecorator(
                  decoration: InputDecoration(
                      labelText: 'Please choose the Issue Title: '),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      items: title.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: Text('Issue Title'),
                      iconSize: 40.0,
                      elevation: 16,
                      onChanged: (String titleSave) {
                        setState(() {
                          //var issue;
                          issue.issuetitle = titleSave;
                          currentTitle = titleSave;
                          print(currentTitle);
                        });
                      },
                      value: currentTitle,
                    ),
                  ));
            }),
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                currentTitle = issue.issuetitle;

                /*if (statusController.text.length < 5) {
                                                      Toast.show(
                                                          "Status should be more than 5 characters long", context,
                                                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      return;
                                                    }*/
                http.post(urlupdatetitle, body: {
                  "issueid": widget.issue.issueid,
                  "issuetitle": currentTitle,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.issue.issuetitle = dres[2];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.issue.issuetitle = dres[2];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onEditCategory() {
    //print("Delete");
    print(widget.issue.issuestatus);
    if (widget.issue.issuestatus == "Progress" ||
        widget.issue.issuestatus == "Finish") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    //String issue;
    //TextEditingController statusController = TextEditingController();
    // flutter defined function
    //print(widget.jpp.name);
    /*if (widget.jpp.name == "not register") {
                                          Toast.show("Not allowed", context,
                                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                          return;
                                        }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Change Issue Status"),
          /*content: new TextField(
                                                  controller: statusController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Status',
                                                    //icon: Icon(Icons.person),
                                                  )),*/

          title: Container(
            child: FormField(builder: (FormFieldState state) {
              return InputDecorator(
                  decoration: InputDecoration(
                      labelText: 'Please choose the Issue Category: '),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      items: category.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: Text('Issue Category'),
                      iconSize: 40.0,
                      elevation: 16,
                      onChanged: (String categorySave) {
                        setState(() {
                          //var issue;
                          issue.issuecategory = categorySave;
                          currentCategory = categorySave;
                          print(currentCategory);
                        });
                      },
                      value: currentCategory,
                    ),
                  ));
            }),
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                currentCategory = issue.issuecategory;

                /*if (statusController.text.length < 5) {
                                                      Toast.show(
                                                          "Status should be more than 5 characters long", context,
                                                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      return;
                                                    }*/
                http.post(urlupdatecategory, body: {
                  "issueid": widget.issue.issueid,
                  "issuecategory": currentCategory,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.issue.issuecategory = dres[8];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.issue.issuecategory = dres[8];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*void _onEditPicture() {
    if (widget.issue.issuestatus == "Progress" ||
        widget.issue.issuestatus == "Finish") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new Issue Picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.staff.email,
                  "issueid": widget.issue.issueid,
                  "issuetitle": widget.issue.issuetitle,
                  "issueowneremail": widget.issue.issueowneremail,
                  "issueownername": widget.issue.issueownername,
                  "issuedesc": widget.issue.issuedes,
                  "issuetime": widget.issue.issuetime,
                  "issueimage": widget.issue.issueimage,
                  "issuecategory": widget.issue.issuecategory,
                  "issuestatus": widget.issue.issuestatus,
                  "isusetaskcomment": widget.issue.issuetaskcomment
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/
}
