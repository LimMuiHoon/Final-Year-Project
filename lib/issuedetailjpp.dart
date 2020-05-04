import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tracking_soc/newissue.dart';
import 'package:tracking_soc/socmanagement.dart';
import 'package:tracking_soc/jpp.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_soc/staff.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tracking_soc/issue.dart';
import 'mainscreen.dart';
//import 'package:flutter/src/widget/text.dart';

String urlupdate =
    "https://limmuihoon.com/trackingsoc/php/update_issue_status.php";
String urlupdatecomment =
    "http://limmuihoon.com/trackingsoc/php/update_issue_task_commentict.php";
String urldelete = "http://limmuihoon.com/trackingsoc/php/delete_issuejpp.php";

class IssueDetailJpp extends StatefulWidget {
  final Issue issue;
  final Staff staff;
  final SocManagement socmanagement;
  final JPP jpp;
  const IssueDetailJpp({
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
  _IssueDetailJppState createState() => _IssueDetailJppState();
}

class _IssueDetailJppState extends State<IssueDetailJpp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ISSUE STATUS'),
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
            jpp: widget.jpp,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Issue issue;
  final Staff jpp;
  DetailInterface({this.issue, this.jpp, Staff staff});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  //Completer<GoogleMapController> _controller = Completer();
  //CameraPosition _myLocation;
  List<DropdownMenuItem<String>> listStatus = [];
  List<String> status = ["New", "Progress", "Finish"];
  String currentstatus = 'New';

  void loadData() {
    listStatus = [];
    listStatus = status
        .map((val) => new DropdownMenuItem(
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
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Update Issue Status',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _updateStatus,
                ),
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Update Issue Task Comment',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _updateComment,
                ),
              ),
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
                                                                      child: MaterialButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(15.0)),
                                                                        height: 40,
                                                                        child: Text(
                                                                          'ACCEPT ISSUE',
                                                                          style: TextStyle(fontSize: 16),
                                                                        ),
                                                                        color: Colors.blueAccent,
                                                                        textColor: Colors.white,
                                                                        elevation: 5,
                                                                        onPressed: _onAcceptBarter,
                                                                      ),
                                                                      //MapSample(),
                                                                    )*/
            ],
          ),
        ),
      ],
    );
  }

  void _updateStatus() {
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
                      labelText: 'Please choose the Issue Status: '),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      items: status.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: Text('Issue Status'),
                      iconSize: 40.0,
                      elevation: 16,
                      onChanged: (String statusSave) {
                        setState(() {
                          //var issue;
                          issue.issuestatus = statusSave;
                          currentstatus = statusSave;
                          print(currentstatus);
                        });
                      },
                      value: currentstatus,
                    ),
                  ));
            }),
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                currentstatus = issue.issuestatus;

                /*if (statusController.text.length < 5) {
                                                      Toast.show(
                                                          "Status should be more than 5 characters long", context,
                                                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      return;
                                                    }*/
                http.post(urlupdate, body: {
                  "issueid": widget.issue.issueid,
                  "issuestatus": currentstatus,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.issue.issuestatus = dres[9];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.issue.issuestatus = dres[9];
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

  void _updateComment() {
    //String issue;
    TextEditingController commentController = TextEditingController();
    // flutter defined function
    /*print(widget.jpp.name);
                      if (widget.jpp.name == "not register") {
                        Toast.show("Not allowed", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Issue Task Comment"),
          content: new TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Comment',
                //icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (commentController.text.length < 5) {
                  Toast.show(
                      "Comment should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdatecomment, body: {
                  "issueid": widget.issue.issueid,
                  "issuetaskcomment": commentController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.issue.issuetaskcomment = dres[12];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.issue.issuetaskcomment = dres[12];
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

  void _onIssueDelete() {
    print("Delete");
    print(widget.issue.issuestatus);
    if (widget.issue.issuestatus == "New" ||
        widget.issue.issuestatus == "Progress") {
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
}

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

void _showDialog() {
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
}
