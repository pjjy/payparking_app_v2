import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payparking_app/utils/db_helper.dart';



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
                     return InkWell(

                       onLongPress: () {

                         showDialog(
                           barrierDismissible: false,
                           context: context,
                           builder: (BuildContext context) {
                             // return object of type Dialog
                             return CupertinoAlertDialog(
                               title: new Text(plateData[index]["plate_number"]),
                               content: new Text("Successfully Added"),
                               actions: <Widget>[
                                 // usually buttons at the bottom of the dialog
                                 new FlatButton(
                                   child: new Text("Close"),
                                   onPressed: () {
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
                               title:Text('$f. Plate No : ${plateData[index]["plate_number"]}',style: TextStyle(fontSize: 26.0),),
                               subtitle: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text('      Time In : ${plateData[index]["dateTimeToday"]}',style: TextStyle(fontSize: 19.0),),
                                   Text('      Entrance Fee : '+oCcy.format(int.parse(plateData[index]["amount"])),style: TextStyle(fontSize: 19.0),),
                                   Text('      Penalty : '+oCcy.format(10000),style: TextStyle(fontSize: 19.0),),
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


