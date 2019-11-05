import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:timeago/timeago.dart' as timeAgo;



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
    geData();
  }

  Future geData() async{
    print('Pending refresh');
  }

  Future passDataToHistoryWithOutPay(id,plateNo,dateTimeIn,dateTimeNow,amount,user) async{

    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd:hh:mm a").format(dateTimeNow);
    var amountPay = amount;
    var penalty = 0;
    var violation = 0;
    print(id);
    print(plateNumber);
    print(dateIn);
    print(dateNow);
    print(amountPay);
    print(penalty);
    print(user);

    //insert to history tbl
    await db.addTransHistory(plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),violation.toString(),user);
    //update  status to 0
    await db.updatePayTranStat(id);
    getTransData();

  }

  Future passDataToHistoryWithPay(id,plateNo,dateTimeIn,dateTimeNow,amount,user,penalty,violation) async{

    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd:hh:mm a").format(dateTimeNow);
    var amountPay = amount;

    print(id);
    print(plateNumber);
    print(dateIn);
    print(dateNow);
    print(amountPay);
    print(penalty);
    print(violation);
    print(user);
    print('pass ni bayad');

    //insert to history tbl
    await db.addTransHistory(plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),violation.toString(),user);
    //update  status to 0
    await db.updatePayTranStat(id);
    getTransData();
    //code for print
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
        title: Text('Transaction List'),
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),

        actions: <Widget>[

          FlatButton.icon(
//            color: Colors.red,
            icon: Icon(Icons.sync),
            label: Text('Last Sync:10/20/19'),
            onPressed: () {
              //Code to execute
              //...
            },
          ),
        ],
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
                      alertText = "Do you log out this person?";
                      alertButton = "Logout";
                      trigger = 0;

                    }if(difference >= 2){
                      alertText = "Please Print a Receipt";
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
                    }
                    if(difference >= 16 && vType == '50'){
                      penalty = 140;
                    }
                    if(difference >= 17 && vType == '50'){
                      penalty = 150;
                    }
                    if(difference >= 18 && vType == '50'){
                      violation = 500;
                    }
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


