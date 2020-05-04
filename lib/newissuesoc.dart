import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tracking_soc/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_soc/socmanagement.dart';
import 'package:tracking_soc/staff.dart';
//import 'package:tracking_soc/jpp.dart';
//import 'package:tracking_soc/issue.dart';
import 'package:tracking_soc/help.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
String urlUploadJPP = "https://limmuihoon.com/trackingsoc/php/upload_jpp.php";
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

TextEditingController _titlecontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _catcontroller = TextEditingController();
//final Staff staff = new Staff();
//final Issue issue = new Issue();
//final JPP jpp = new JPP();
//String _issuetitle, _issuedesc, _issuecategory;

class NewIssueSoc extends StatefulWidget {
  final SocManagement socmanagement;
  //final Issue issue;
  //final JPP jpp;
  const NewIssueSoc({Key key, this.socmanagement}) : super(key: key);

  @override
  _NewIssueSocState createState() => _NewIssueSocState();
}

class _NewIssueSocState extends State<NewIssueSoc> {
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
              child: CreateNewIssue(widget.socmanagement),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            socmanagement: widget.socmanagement,
          ),
        ));
    return Future.value(false);
  }
}

class CreateNewIssue extends StatefulWidget {
  final SocManagement socmanagement;
  //final Issue issue;
  CreateNewIssue(
    this.socmanagement,
  );

  @override
  _CreateNewIssueState createState() => _CreateNewIssueState();
}

class _CreateNewIssueState extends State<CreateNewIssue> {
  String defaultValue = 'Pickup';

  /*List<DropdownMenuItem<String>> listCategory = [];
  List<String> category = [
    "JPP",
    "Jabatan Keselamatan",
    "Pusat Unit ICT SOC",
    "UUMIT"
  ];
  String currentCategory = 'JPP';*/

  /*void loadData() {
    listCategory = [];
    listCategory = category
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();
  }*/

  @override
  void initState() {
    super.initState();
    //loadData();
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
        Text('Click on image above to take new issue picture'),
        TextField(
            controller: _titlecontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Issue Title',
              icon: Icon(Icons.title),
            )),
        TextField(
            controller: _desccontroller,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.previous,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Issue Description',
              counterStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              icon: Icon(Icons.info),
            )),
        TextField(
            controller: _catcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Issue Category',
              counterStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              icon: Icon(Icons.info),
            )),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
            //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            onTap: _onHelp,
            child: Text('Help Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
        /*FormField(builder: (FormFieldState state) {
          return InputDecorator(
              decoration: InputDecoration(
                  labelText: 'Please choose the Responsible Person Category: '),
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
        SizedBox(
          height: 20,
        ),
        Text('Confirm Send to: ',
            style: TextStyle(fontSize: 15, letterSpacing: 0.1)),
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
                  'JPP',
                  style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                ),
                color: Colors.blue[700],
                textColor: Colors.white,
                elevation: 15,
                onPressed: _onsendtoJPP,
              ),
              MaterialButton(
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
              ),
              MaterialButton(
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
              ),
              MaterialButton(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _choose() async {
    _image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400);
    setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onsendtoJPP() {
    print('onsendtoJPP Button from Send Issue to JPP()');
    //print(_image.toString());
    //_issuetitle = _titlecontroller.text;
    //_issuedesc = _desccontroller.text;
    //_issuecategory = _catcontroller.text;
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter issue title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
      "issuetitle": _titlecontroller.text,
      "email": widget.socmanagement.email,
      "name": widget.socmanagement.name,
      "issuedesc": _desccontroller.text,
      "issuecategory": _catcontroller.text,
    }).then((res) {
      print(urlUploadJPP);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = '';
        _desccontroller.text = '';
        _catcontroller.text = '';
        pr.dismiss();
        print(widget.socmanagement.email);
        //print(widget.staff.name);
        _onLoginJPP(widget.socmanagement.email, context);
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
  }

  void _onsendtojabatankeselamatan() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter issue title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
      "email": widget.socmanagement.email,
      "issuetitle": _titlecontroller.text,
      "issuedesc": _desccontroller.text,
      "issuecategory": _catcontroller.text,
      "name": widget.socmanagement.name
    }).then((res) {
      print(urlUploadJPP);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.socmanagement.email);
        _onLoginJabatanKeselamatan(widget.socmanagement.email, context);
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

  void _onLoginJabatanKeselamatan(String email, BuildContext context) {
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
  }

  void _onsendtopusatunitictsoc() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter issue title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
      "email": widget.socmanagement.email,
      "issuetitle": _titlecontroller.text,
      "issuedesc": _desccontroller.text,
      "issuecategory": _catcontroller.text,
      "name": widget.socmanagement.name
    }).then((res) {
      print(urlUploadPusatUnitIctSoc);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.socmanagement.email);
        _onLoginPusatUnitIctSoc(widget.socmanagement.email, context);
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

  void _onLoginPusatUnitIctSoc(String email, BuildContext context) {
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
  }

  void _onsendtouumit() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter issue title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
      "email": widget.socmanagement.email,
      "issuetitle": _titlecontroller.text,
      "issuedesc": _desccontroller.text,
      "issuecategory": _catcontroller.text,
      "name": widget.socmanagement.name
    }).then((res) {
      print(urlUploadUUMIT);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.socmanagement.email);
        _onLoginUUMIT(widget.socmanagement.email, context);
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

  void _onLoginUUMIT(String email, BuildContext context) {
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
  }

  void _onHelp() {
    print('onHelpInfo');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HelpScreen()));
  }
}
