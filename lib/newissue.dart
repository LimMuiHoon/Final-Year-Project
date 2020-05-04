import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tracking_soc/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_soc/staff.dart';
import 'package:tracking_soc/issue.dart';
import 'package:tracking_soc/jpp.dart';
import 'package:tracking_soc/pusatunitictsoc.dart';
import 'package:tracking_soc/jabatankeselamatan.dart';
import 'package:tracking_soc/uumit.dart';
//import 'package:tracking_soc/issue.dart';
import 'package:tracking_soc/help.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:flutter/src/material/dropdown.dart';
/*void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}*/

File _image;
String pathAsset = 'assets/images/problem.png';
//String urlUploadJPP = "https://limmuihoon.com/trackingsoc/php/upload.php";
String urlUploadJPP = "http://limmuihoon.com/trackingsoc/php/uploadissue1.php";
String urlUploadJabatanKeselamatan =
    "http://limmuihoon.com/trackingsoc/php/upload_jabatankeselamatan.php";
String urlUploadPusatUnitIctSoc =
    "http://limmuihoon.com/trackingsoc/php/upload_pusatunitictsoc.php";
String urlUploadUUMIT =
    "http://limmuihoon.com/trackingsoc/php/upload_uumit.php";
String urlgetstaffJPP =
    "http://limmuihoon.com/trackingsoc/php/get_staffjpp.php";
String urlgetstaffJabKeselamatan =
    "http://limmuihoon.com/trackingsoc/php/get_staffjabatankeselamatan.php";
String urlgetstaffPusatUnitIctSoc =
    "http://limmuihoon.com/trackingsoc/php/get_staffpusatunitictsoc.php";
String urlgetstaffUUNIT =
    "http://limmuihoon.com/trackingsoc/php/get_staffuumit.php";

//String _issuedesc;
//TextEditingController _titlecontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
//final TextEditingController _catcontroller = TextEditingController();
final Staff staff = new Staff();
final Issue issue = new Issue();
//final JPP jpp = new JPP();

class NewIssue extends StatefulWidget {
  final Staff staff;
  final Issue issue;
  final JPP jpp;
  final JabatanKeselamatan jabatankeselamatan;
  final PusatUnitICTSOC pusatunitictsoc;
  final UUMIT uumit;
  const NewIssue(
      {Key key,
      this.staff,
      this.jpp,
      this.jabatankeselamatan,
      this.pusatunitictsoc,
      this.uumit,
      this.issue})
      : super(key: key);

  @override
  _NewIssueState createState() => _NewIssueState();
}

class _NewIssueState extends State<NewIssue> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text('ADD NEW ISSUE'),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: CreateNewIssue(widget.staff),
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
            //jpp: widget.jpp,
            //jabatankeselamatan: widget.jabatankeselamatan,
          ),
        ));
    return Future.value(false);
  }
}

class CreateNewIssue extends StatefulWidget {
  final Staff staff;
  //final JPP jpp;
  //final Issue issue;
  CreateNewIssue(
    this.staff,
    //this.issue,
  );

  @override
  _CreateNewIssueState createState() => _CreateNewIssueState();
}

class _CreateNewIssueState extends State<CreateNewIssue> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autoValidate = false;
  String defaultValue = 'Pickup';

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
    "System/Internet"
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
    //loadDataa();
    //_getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        SizedBox(
          height: 10,
        ),
        Text('Click on image above to take new issue picture'),
        Text('*Required take picture*', style: TextStyle(color: Colors.red)),

        /*TextField(
            controller: _catcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Responsible Department',
              counterStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              icon: Icon(Icons.info),
            )),*/
        /*TextField(
            controller: _titlecontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Issue Title',
              icon: Icon(Icons.title),
            )),*/
        GestureDetector(
          //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          onTap: _onHelp,
          child: new Text('*Help Info*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent[700],
                //Icon(Icons.help),
                //textColor: Colors.white,
                fontSize: 30,
                //Icon(Icons.help),
              )),
        ),
        Text("Click to view Help Info!"),
        Column(
          children: <Widget>[
            Container(
              child: FormField(builder: (FormFieldState state) {
                return InputDecorator(
                    decoration: InputDecoration(
                        labelText:
                            'Please choose the Responsible Department: '),
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        items: category.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text('Responsible Department'),
                        iconSize: 40.0,
                        elevation: 16,
                        onChanged: (String categorySave) {
                          setState(() {
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
          ],
        ),
        Text('*Required choose Responsible Department/Category*',
            style: TextStyle(color: Colors.red)),
        Column(
          children: <Widget>[
            Container(
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
          ],
        ),
        Text('*Required choose issue title*',
            style: TextStyle(color: Colors.red)),
        TextFormField(
            autovalidate: _autoValidate,
            controller: _desccontroller,
            validator: validateDescription,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.previous,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Issue Description',
              counterStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              icon: Icon(Icons.info),
            )),
        Text('*Required key in issue description*',
            style: TextStyle(color: Colors.red)),
        SizedBox(
          height: 5,
        ),
        /*GestureDetector(
                        //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        onTap: _onHelp,
                        child: Text('Help Info',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent[700],
                              //textColor: Colors.white,
                              fontSize: 30,
                            ))),*/

        /*FormField(builder: (FormFieldState state) {
                      return InputDecorator(
                          decoration: InputDecoration(
                              labelText:
                                  'Please choose the Responsible Person Department: '),
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: category.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: Text('Category'),
                              iconSize: 40.0,
                              elevation: 16,
                              onChanged: (String categorySave) {
                                setState(() {
                                  issue.issuecategory = categorySave;
                                  currentCategory = categorySave;
                                  print(currentCategory);
                                });
                              },
                              value: currentCategory,
                            ),
                          ));
                    }),*/
        /*FormField(builder: (FormFieldState state) {
                      return InputDecorator(
                          decoration:
                              InputDecoration(labelText: 'Please choose the Issue Title: '),
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: category.map((String val) {
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
                                  issue.issuetitle = titleSave;
                                  currentTitle = titleSave;
                                  print(currentTitle);
                                });
                              },
                              value: currentTitle,
                            ),
                          ));
                    }),*/
        SizedBox(
          height: 20,
        ),
        /*FormField(builder: (FormFieldState state) {
                      return InputDecorator(
                          decoration:
                              InputDecoration(labelText: 'Please choose the Issue Title: '),
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              items: category.map((String val) {
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
                                  issue.issuetitle = titleSave;
                                  currentTitle = titleSave;
                                  print(currentTitle);
                                });
                              },
                              value: currentTitle,
                            ),
                          ));
                    }),
                    SizedBox(
                      height: 20,
                    ),*/
        Text(' ', style: TextStyle(fontSize: 15, letterSpacing: 0.1)),
        SizedBox(
          height: 5,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 10,
                height: 30,
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 30, letterSpacing: 0.8),
                ),
                color: Colors.blue[700],
                textColor: Colors.white,
                elevation: 20,
                onPressed: _onsendtoJPP,
              ),
              /*MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 10,
                            height: 30,
                            child: Text(
                              'Security Department',
                              style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                            ),
                            color: Colors.blue[700],
                            textColor: Colors.white,
                            elevation: 15,
                            onPressed: _onsendtojabatankeselamatan,
                          ),*/
              /*MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 10,
                            height: 30,
                            child: Text(
                              'SOC ICT Unit',
                              style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                            ),
                            color: Colors.blue[700],
                            textColor: Colors.white,
                            elevation: 15,
                            onPressed: _onsendtopusatunitictsoc,
                          ),*/
              /*MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 10,
                            height: 30,
                            child: Text(
                              'UUMIT',
                              style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                            ),
                            color: Colors.blue[700],
                            textColor: Colors.white,
                            elevation: 15,
                            onPressed: _onsendtouumit,
                          ),*/
            ],
          ),
        ),
      ],
    );
  }

  void _choose() async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 60,
                        maxHeight: 250,
                        maxWidth: 250);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 60,
                        maxHeight: 250,
                        maxWidth: 250);
                    setState(() {});
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
    //selection==null?_image = await ImagePicker.pickImage(source: ImageSource.camera):await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onsendtoJPP() {
    print('onsendtoJPP Button from Send Issue to JPP()');
    //print(_image.toString());
    //_issuetitle = _titlecontroller.text;
    //_issuedesc = _desccontroller.text;
    currentCategory = issue.issuecategory;
    currentTitle = issue.issuetitle;
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    /*if (_titlecontroller.text.isEmpty) {
                  Toast.show("Please enter issue title", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }*/
    if (_desccontroller.text.isEmpty) {
      Toast.show("Please enter issue description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    /*if (_catcontroller.text.length < 2) {
                  Toast.show("Please enter issue Category", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }*/
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(urlUploadJPP, body: {
      "encoded_string": base64Image,
      "issuetitle": currentTitle,
      "email": widget.staff.email,
      "name": widget.staff.name,
      "issuedesc": _desccontroller.text,
      "issuecategory": currentCategory,
    }).then((res) {
      print(urlUploadJPP);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        // _titlecontroller.text = '';
        _desccontroller.text = '';
        //_catcontroller.text = '';
        pr.dismiss();
        print(widget.staff.email);
        //print(widget.staff.name);
        _onLoginJPP(widget.staff.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _onLoginJPP(String email, BuildContext context) {
    http.post(urlgetstaffJPP, body: {
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(staff: staff)));
      }
    }).catchError((err) {
      print(err);
    });
    setState(() {
      _autoValidate = true;
    });
  }

  /*void _onsendtojabatankeselamatan() {
                if (_image == null) {
                  Toast.show("Please take picture", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                /*if (_titlecontroller.text.isEmpty) {
                  Toast.show("Please enter issue title", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }*/
                if (_desccontroller.text.isEmpty) {
                  Toast.show("Please enter issue description", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                ProgressDialog pr = new ProgressDialog(context,
                    type: ProgressDialogType.Normal, isDismissible: false);
                pr.style(message: "Requesting...");
                pr.show();
                String base64Image = base64Encode(_image.readAsBytesSync());
                /*print(_currentPosition.latitude.toString() +
                                                                                "/" +
                                                                                _currentPosition.longitude.toString());*/
            
                http.post(urlUploadJabatanKeselamatan, body: {
                  "encoded_string": base64Image,
                  "email": widget.staff.email,
                  "issuetitle": currentTitle,
                  "issuedesc": _desccontroller.text,
                  "issuecategory": currentCategory,
                  "name": widget.staff.name
                }).then((res) {
                  print(urlUploadJPP);
                  Toast.show(res.body, context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  if (res.body.contains("success")) {
                    _image = null;
                    //_titlecontroller.text = "";
                    _desccontroller.text = "";
                    pr.dismiss();
                    print(widget.staff.email);
                    _onLoginJabatanKeselamatan(widget.staff.email, context);
                  } else {
                    pr.dismiss();
                    Toast.show(res.body + ". Please reload", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                  pr.dismiss();
                });
              }*/

  /*void _onLoginJabatanKeselamatan(String email, BuildContext context) {
                http.post(urlgetstaffJabKeselamatan, body: {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen(staff: staff)));
                  }
                }).catchError((err) {
                  print(err);
                });
              }*/

  /* void _onsendtopusatunitictsoc() {
                if (_image == null) {
                  Toast.show("Please take picture", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                /*if (_titlecontroller.text.isEmpty) {
                  Toast.show("Please enter issue title", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }*/
                if (_desccontroller.text.isEmpty) {
                  Toast.show("Please enter issue description", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                ProgressDialog pr = new ProgressDialog(context,
                    type: ProgressDialogType.Normal, isDismissible: false);
                pr.style(message: "Requesting...");
                pr.show();
                String base64Image = base64Encode(_image.readAsBytesSync());
                /*print(_currentPosition.latitude.toString() +
                                                                                "/" +
                                                                                _currentPosition.longitude.toString());*/
            
                http.post(urlUploadPusatUnitIctSoc, body: {
                  "encoded_string": base64Image,
                  "email": widget.staff.email,
                  "issuetitle": currentTitle,
                  "issuedesc": _desccontroller.text,
                  "issuecategory": currentCategory,
                  "name": widget.staff.name
                }).then((res) {
                  print(urlUploadPusatUnitIctSoc);
                  Toast.show(res.body, context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  if (res.body.contains("success")) {
                    _image = null;
                    //_titlecontroller.text = "";
                    _desccontroller.text = "";
                    pr.dismiss();
                    print(widget.staff.email);
                    _onLoginPusatUnitIctSoc(widget.staff.email, context);
                  } else {
                    pr.dismiss();
                    Toast.show(res.body + ". Please reload", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                  pr.dismiss();
                });
              }*/

  /*void _onLoginPusatUnitIctSoc(String email, BuildContext context) {
                http.post(urlgetstaffPusatUnitIctSoc, body: {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen(staff: staff)));
                  }
                }).catchError((err) {
                  print(err);
                });
              }*/

  /*void _onsendtouumit() {
                if (_image == null) {
                  Toast.show("Please take picture", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                /*if (_titlecontroller.text.isEmpty) {
                  Toast.show("Please enter issue title", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }*/
                if (_desccontroller.text.isEmpty) {
                  Toast.show("Please enter issue description", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                ProgressDialog pr = new ProgressDialog(context,
                    type: ProgressDialogType.Normal, isDismissible: false);
                pr.style(message: "Requesting...");
                pr.show();
                String base64Image = base64Encode(_image.readAsBytesSync());
                /*print(_currentPosition.latitude.toString() +
                                                                                "/" +
                                                                                _currentPosition.longitude.toString());*/
            
                http.post(urlUploadUUMIT, body: {
                  "encoded_string": base64Image,
                  "email": widget.staff.email,
                  "issuetitle": currentTitle,
                  "issuedesc": _desccontroller.text,
                  "issuecategory": currentCategory,
                  "name": widget.staff.name
                }).then((res) {
                  print(urlUploadUUMIT);
                  Toast.show(res.body, context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  if (res.body.contains("success")) {
                    _image = null;
                    //_titlecontroller.text = "";
                    _desccontroller.text = "";
                    pr.dismiss();
                    print(widget.staff.email);
                    _onLoginUUMIT(widget.staff.email, context);
                  } else {
                    pr.dismiss();
                    Toast.show(res.body + ". Please reload", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                  pr.dismiss();
                });
              }*/

  /*void _onLoginUUMIT(String email, BuildContext context) {
                http.post(urlgetstaffUUNIT, body: {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen(staff: staff)));
                  }
                }).catchError((err) {
                  print(err);
                });
              }*/

  void _onHelp() {
    print('onHelpInfo');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HelpScreen()));
  }

  String validateDescription(String value) {
    if (value.length == 0) {
      return "Please enter your issue description";
    } else {
      return null;
    }
  }
}
