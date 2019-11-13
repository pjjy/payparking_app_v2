import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:fluttertoast/fluttertoast.dart';



class ParkTransList extends StatefulWidget {
  @override
  _ParkTransList createState() => _ParkTransList();
}

class _ParkTransList extends State<ParkTransList> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final db = PayParkingDatabase();
  List plateData;



  Future getTransData() async {
    var res = await db.fetchAll();
    setState((){
      plateData = res;
    });
  }



  Future passDataToHistoryWithOutPay(id,plateNo,dateTimeIn,dateTimeNow,amount,user) async{

    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd : hh:mm a").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd : hh:mm a").format(dateTimeNow);
    var amountPay = amount;
    var penalty = 0;
    var violation = 0;


    //insert to history tbl
    await db.addTransHistory(plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),violation.toString(),user);
    //update  status to 0
    await db.updatePayTranStat(id);
    getTransData();
    //code for print
    Fluttertoast.showToast(
        msg: "Successfully added to history",
        toastLength: Toast.LENGTH_LONG ,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  Future passDataToHistoryWithPay(id,plateNo,dateTimeIn,dateTimeNow,amount,user,penalty,violation) async{

    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd : hh:mm a").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd : hh:mm a").format(dateTimeNow);
    var amountPay = amount;


    //insert to history tbl
    await db.addTransHistory(plateNumber,dateIn.toString(),dateNow,amountPay.toString(),penalty.toString(),violation.toString(),user);
    //update  status to 0
    await db.updatePayTranStat(id);
    getTransData();
    //code for print
    Fluttertoast.showToast(
        msg: "Successfully added to history",
        toastLength: Toast.LENGTH_LONG ,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState(){
    super.initState();
    getTransData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Transactions List',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),

        body:Column(

          children: <Widget>[
           Expanded(
               child:RefreshIndicator(
                 onRefresh: getTransData,
                 child:ListView.builder(
//                 physics: BouncingScrollPhysics(),
                   itemCount: plateData == null ? 0: plateData.length,
                   itemBuilder: (BuildContext context, int index) {
                    var f = index;
                    f++;
                    var trigger;
                    var penalty = 0;
                    var violation = 0;
                    String alertText;
                    String alertButton;

                    var dateString = plateData[index]["dateToday"]; //getting time
                    var date = dateString.split("-"); //split time
                    var hrString = plateData[index]["dateTimeToday"]; //getting time
                    var hour = hrString.split(":"); //split time
                    var vType = plateData[index]["amount"];


                    final dateTimeIn = DateTime(int.parse(date[0]),int.parse(date[1]),int.parse(date[2]),int.parse(hour[0]),int.parse(hour[1]));
                    final dateTimeNow = DateTime.now();
                    final difference = dateTimeNow.difference(dateTimeIn).inHours;
                    final fifteenAgo = new DateTime.now().subtract(new Duration(hours: difference));
                    final timeAg = timeAgo.format(fifteenAgo);

                    if(difference < 2){
                      alertText = "Do you want to log out this person?";
                      alertButton = "Logout";
                      trigger = 0;

                    }if(difference >= 2){
                      alertText = "Do you want log out this person?";
                      alertButton = "Logout & Print";
                      trigger = 1;
                    }

                    if(difference >= 3 && vType == '100'){
                      penalty = 20;
                    }
                    if(difference >= 4 && vType == '100'){
                      penalty = 40;
                    }
                    if(difference >= 5 && vType == '100'){
                      penalty = 60;
                    }
                    if(difference >= 6 && vType == '100'){
                      penalty = 80;
                    }
                    if(difference >= 7 && vType == '100'){
                      penalty = 100;
                    }
                    if(difference >= 8 && vType == '100'){
                      penalty = 120;
                    }
                    if(difference >= 9 && vType == '100'){
                      penalty = 140;
                    }
                    if(difference >= 10 && vType == '100'){
                      penalty = 160;
                    }
                    if(difference >= 11 && vType == '100'){
                      penalty = 180;
                    }
                    if(difference >= 12 && vType == '100'){
                      penalty = 200;
                    }
                    if(difference >= 13 && vType == '100'){
                      penalty = 220;
                    }
                    if(difference >= 14 && vType == '100'){
                      penalty = 240;
                    }
                    if(difference >= 15 && vType == '100'){
                      penalty = 260;
                    }
                    if(difference >= 16 && vType == '100'){
                      penalty = 280;
                    }
                    if(difference >= 17 && vType == '100'){
                      penalty = 300;
                    }
                    if(difference >= 18 && vType == '100'){
                      violation = 500;
                    }
                    //for 2 wheels
                    if(difference >= 3 && vType == '50'){
                      penalty = 10;
                    }
                    if(difference >= 4 && vType == '50'){
                      penalty = 20;
                    }
                    if(difference >= 5 && vType == '50'){
                      penalty = 30;
                    }
                    if(difference >= 6 && vType == '50'){
                      penalty = 40;
                    }
                    if(difference >= 7 && vType == '50'){
                      penalty = 50;
                    }
                    if(difference >= 8 && vType == '50'){
                      penalty = 60;
                    }
                    if(difference >= 9 && vType == '50'){
                      penalty = 70;
                    }
                    if(difference >= 10 && vType == '50'){
                      penalty = 80;
                    }
                    if(difference >= 11 && vType == '50'){
                      penalty = 90;
                    }
                    if(difference >= 12 && vType == '50'){
                      penalty = 100;
                    }
                    if(difference >= 13 && vType == '50'){
                      penalty = 110;
                    }
                    if(difference >= 14 && vType == '50'){
                      penalty = 120;
                    }
                    if(difference >= 15 && vType == '50'){
                      penalty = 130;
                      violation = 500;
                    }
                    if(difference >= 16 && vType == '50'){
                      penalty = 140;
                    }
                    if(difference >= 17 && vType == '50'){
                      penalty = 150;
                    }
//                    if(DateFormat("H:mm").format(new DateTime.now()) == 18 && vType == '50'){
//                      violation = 500;
//                    }
                    var totalAmount = penalty + violation + num.parse(vType);


                     return InkWell(
                       onLongPress: (){
                         showDialog(
                           barrierDismissible: false,
                           context: context,
                           builder: (BuildContext context) {
                             // return object of type Dialog
                             return CupertinoAlertDialog(
                               title: new Text(plateData[index]["plateNumber"]),
                               content: new Text(alertText),
                               actions: <Widget>[
                                 // usually buttons at the bottom of the dialog
                                 new FlatButton(
                                   child: new Text(alertButton),
                                    onPressed: () {
                                     if(trigger == 0){
                                        passDataToHistoryWithOutPay(plateData[index]["id"],plateData[index]["plateNumber"],dateTimeIn,DateTime.now(),plateData[index]["amount"],plateData[index]["user"]);
                                     }
                                     if(trigger == 1){
                                        passDataToHistoryWithPay(plateData[index]["id"],plateData[index]["plateNumber"],dateTimeIn,DateTime.now(),plateData[index]["amount"],plateData[index]["user"],penalty,violation);
                                     }
                                     Navigator.of(context).pop();
                                   },
                                 ),
                                 new FlatButton(
                                   child: new Text("Close"),
                                   onPressed: () {
                                     Navigator.of(context).pop();
                                   },
                                 ),
                               ],
                             );
                           },
                         );
                       },
                       child: Card(
                         margin: EdgeInsets.all(5),
                         elevation: 0.0,
                         child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             ListTile(
                               title:Text('$f. Plate No : ${plateData[index]["plateNumber"]}',style: TextStyle(fontSize: 26.0),),
                               subtitle: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text('      Time In : '+DateFormat("yyyy-MM-dd hh:mm a").format(dateTimeIn),style: TextStyle(fontSize: 17.0),),
                                   Text('      Entrance Fee : '+oCcy.format(int.parse(plateData[index]["amount"])),style: TextStyle(fontSize: 17.0),),
                                   Text('      Time lapse : $timeAg',style: TextStyle(fontSize: 17.0),),
                                   Text('      Penalty : '+oCcy.format(penalty),style: TextStyle(fontSize: 17.0),),
                                   Text('      Cut-off Violation : '+oCcy.format(violation),style: TextStyle(fontSize: 17.0),),
                                   Text('      Total : '+oCcy.format(totalAmount),style: TextStyle(fontSize: 17.0),),
                                 ],
                               ),
//                               trailing: Icon(Icons.more_vert),
                             ),
                           ],
                         ),
                       ),
                     );
                   },
                 ),
               ),
            ),
          ],
        ),



    );
  }
}


