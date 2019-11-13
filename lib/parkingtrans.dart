import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:nice_button/nice_button.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class ParkTrans extends StatefulWidget {
  @override
  _ParkTrans createState() => _ParkTrans();
}
class _ParkTrans extends State<ParkTrans> {

  final db = PayParkingDatabase();


  File pickedImage;
  Future pickImage() async{
    String platePattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"; //email regex  alisdan ug platenumber
    RegExp regEx = RegExp(platePattern);
    String platePatternNew;


    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = imageFile;
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    TextRecognizer recognizedText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizedText.processImage(image);
    if(regEx.hasMatch(readText.text)){
        print(true);
        platePatternNew = readText.text;
//        regEx.firstMatch(platePatternNew).group(0);
        if (this.mounted) {
          setState(() {
            print(regEx.firstMatch(platePatternNew).group(0));
            plateNoController.text = regEx.firstMatch(platePatternNew).group(0);
          });
        }
    }else{
        print(false);
    }
  }


  TextEditingController plateNoController = TextEditingController();

  void confirmed(){
    if(plateNoController.text == ""){
//      var today = new DateTime.now();
//      var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
//      var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
//      print(dateToday);
//      print(dateUntil);
//      print(selectedRadio);
    }
    else {
      if(selectedRadio == 0){

      }
      else{
        saveData();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return CupertinoAlertDialog(
              title: new Text(plateNoController.text),
              content: new Text("Successfully Added ,Printing the Receipt"),
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
   }

  void saveData() async{


      String plateNumber = plateNoController.text;
      var today = new DateTime.now();
      var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
      var dateTimeToday = DateFormat("H:mm").format(new DateTime.now());
      var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
      String amount = selectedRadio.toString();
      var stat = 1;
      var user = 'boss rrrrr';


//      print(plateNumber);
//      print(dateToday);
//      print(dateTimeToday);
//      print(dateUntil);
//      print(amount);
//      print(stat);
//      print(user);


      await db.addTrans(plateNumber,dateToday,dateTimeToday,dateUntil,amount,user,stat);
      Fluttertoast.showToast(
          msg: "Successfully Added to Transactions",
          toastLength: Toast.LENGTH_LONG ,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
  }

  int selectedRadio;
  @override
  void initState(){
    super.initState();
    selectedRadio = 0;
  }
  void setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Park Me',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: ListView(
//          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child:NiceButton(
                width: 255,
                elevation: 0.0,
                radius: 52.0,
                text: "Open Camera",
                icon: Icons.camera_alt,
                padding: const EdgeInsets.all(15),
                background: Colors.blue,
                onPressed:pickImage,
             ),
          ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
              child: new TextFormField(
               controller:plateNoController,
               autofocus: false,
//               enabled: false,
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
            height: 25.0,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child:Text('Vehicle Type',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black),),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
           child: Row(
             children: <Widget>[
               Text("4 Wheels(100)",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
               Radio(
                value: 100,
                groupValue: selectedRadio,
                activeColor: Colors.blue,
                onChanged:(val) {
                    setSelectedRadio(val);
                },
               ),
               Text("2 Wheels(50)",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
               Radio(
                 value: 50,
                 groupValue: selectedRadio,
                 activeColor: Colors.blue,
                 onChanged:(val) {
                   setSelectedRadio(val);
                 },
               ),
             ]
            ),
          ),

          Padding( padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
           child: Container(
//              width: 400.0,
              child: ConfirmationSlider(
                shadow:BoxShadow(color: Colors.black38, offset: Offset(1, 0),blurRadius: 1,spreadRadius: 1,),
                foregroundColor:Colors.blue,
                height:170.0,
                width : width-60,
                onConfirmation: () => confirmed(),
            ),),
        ),
      ],
     ),
    );
  }
}