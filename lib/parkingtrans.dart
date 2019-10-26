import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:nice_button/nice_button.dart';
import 'package:intl/intl.dart';



class ParkTrans extends StatefulWidget {

  @override
  _ParkTrans createState() => _ParkTrans();
}


class _ParkTrans extends State<ParkTrans> {




//  File pickedImage;
//  Future pickImage() async{
//    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
//    setState(() {
//      pickedImage = tempStore;
//    });
//  }



  var now = new DateTime.now();


  TextEditingController plateNoController = TextEditingController();

  void confirmed(){
    if(plateNoController.text == ""){
      var today = new DateTime.now();

      var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
      var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
      print(dateToday);
      print(dateUntil);
    }
    else {
      saveData();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(plateNoController.text),
            content: new Text("Successfully Added"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  plateNoController.text = "";
                },
              ),
            ],
          );
        },
      );
    }
  }

  void saveData(){

    print(plateNoController.text);

//    var today =DateFormat("dd-MM-yyyy").format(now);

    var today = new DateTime.now();

    var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
    var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));

    print(dateToday);
    print(dateUntil);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Home'),
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child:NiceButton(
                width: 255,
                elevation: 0.0,
                radius: 52.0,
                text: "Open Camera",
                icon: Icons.camera,
                padding: const EdgeInsets.all(15),
                background: Colors.blue,
                onPressed: () {
                print("hello");
              },
             ),
      ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: new TextFormField(
               controller:plateNoController,
               autofocus: false,
               enabled: false,
               style: TextStyle(fontSize: 70.0),
                    decoration: InputDecoration(
                    hintText: 'Plate Number',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 40.0, 50.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 30.0),
                        child:  Icon(Icons.directions_car, color: Colors.grey,size: 40.0,),
                      ),
                  ),
            ),
         ),
        Divider(
          color: Colors.transparent,
          height: 10.0,
        ),
    Padding( padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
     child: Container(
        width: 300.0,
        child: ConfirmationSlider(
          shadow:BoxShadow(color: Colors.black38, offset: Offset(1, 0),blurRadius: 1,spreadRadius: 1,),
          foregroundColor:Colors.blue,
          height:170.0,
          width : 570.0,
          onConfirmation: () => confirmed(),
        ),),

    ),

       ],
      ),
    );
  }
}