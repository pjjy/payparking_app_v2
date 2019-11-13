import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SyncingPage extends StatefulWidget {
  @override
  _SyncingPage createState() => new _SyncingPage();
}
class _SyncingPage extends State<SyncingPage> {
   List hisData;
   final db = PayParkingDatabase();

   var appId;
   String plateNumber;
   String dateTimeIn;
   String dateTimeout;
   var amount;
   var penalty;
   String cutOffViolation;
   String user;

   Future syncTransData() async{

    var res = await db.fetchAllHistory();
    setState(() {
      hisData = res;
    });
    if(hisData.isEmpty){
      Navigator.of(context).pop();
      print('wala pay sulod');
    }else{


        for (int i = 0; i < hisData.length; i++) {
            appId =  hisData[i]['id'];
            plateNumber = hisData[i]['plateNumber'];
            dateTimeIn = hisData[i]['dateTimein'];
            dateTimeout = hisData[i]['dateTimeout'];
            amount = hisData[i]['amount'];
            penalty = hisData[i]['penalty'];
            cutOffViolation = hisData[i]['cutOffviolation'];
            user = hisData[i]['user'];

          await http.post("http://172.16.46.130/e_parking/sync_data",body:{
            "id": appId.toString(),
            "plateNumber": plateNumber,
            "dateTimeIn": dateTimeIn,
            "dateTimeout": dateTimeout,
            "amount": amount,
            "penalty": penalty,
            "cutOffViolation": cutOffViolation,
            "user": user,
          });
          if(i == hisData.length-1){
            Fluttertoast.showToast(
                msg: "Data are synced successfully",
                toastLength: Toast.LENGTH_LONG ,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 2,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0
            );
            Navigator.of(context).pop();
            print('done');
          }
        }

// mag code trap sa php para dili ma magbalik2x ang data inag sync
//        print(appId);
//        print(plateNumber);
//        print(dateTimeIn);
//        print(dateTimeout);
//        print(amount);
//        print(penalty);
//        print(cutOffViolation);
//        print(user);


    }
  }



  @override
  void initState(){
    super.initState();
    syncTransData();
  }
  @override
  Widget build(BuildContext context) {
    double setHeight;
    double screenHeight = MediaQuery.of(context).size.height;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if(isPortrait == true){
      setHeight=screenHeight-490;
    }else{
      setHeight=screenHeight-280;
    }
    return new Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height:setHeight,
          ),
          GradientText("Syncing...",
          gradient: LinearGradient(colors: [Colors.deepOrangeAccent, Colors.blue, Colors.pink]),
          style: TextStyle(fontSize: 32),
          textAlign: TextAlign.center),
          SizedBox(
            height: 40,
          ),
          Center(
            child:SpinKitWanderingCubes(
              color: Colors.blue,
              size: 70,
            ),
          ),
        ],
      ),
    );
  }
}