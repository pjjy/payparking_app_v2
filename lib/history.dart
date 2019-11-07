import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class HistoryTransList extends StatefulWidget {
  @override
  _HistoryTransList createState() => _HistoryTransList();
}
class _HistoryTransList extends State<HistoryTransList> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final db = PayParkingDatabase();
  List plateData;
  List syncData;
  String alert;

  Future getSyncDate() async{
    var res = await db.fetchSync();
    setState((){
      syncData = res;
    });
  }



  Future insertSyncDate() async{
    await db.insertSyncDate(DateFormat("yyyy-MM-dd : hh:mm a").format(new DateTime.now()).toString());
    getSyncDate();
  }

  Future getHistoryTransData() async {
    var res = await db.fetchAllHistory();
    setState((){
      plateData = res;
    });

  }

  @override
  void initState(){
    super.initState();
    getHistoryTransData();
    getSyncDate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('History',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
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
            label: Text('Database Sync'),
//            label: Text('Last Sync'+syncData[0]['syncDate']),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return CupertinoAlertDialog(
                    title: new Text("Confirm Data Sync"),
                    content: new Text("Are you sure you to sync?"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Confirm"),
                        onPressed: () {
                          insertSyncDate();
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
          ),
        ],
      ),

      body:Column(

        children: <Widget>[
          Expanded(
            child:RefreshIndicator(
              onRefresh: getHistoryTransData,
              child:ListView.builder(
//                 physics: BouncingScrollPhysics(),
                  itemCount: plateData == null ? 0: plateData.length,
                  itemBuilder: (BuildContext context, int index) {
                  var f = index;
                  f++;

                  var totalAmount = int.parse(plateData[index]["penalty"]) + int.parse(plateData[index]["cutOffviolation"]) + int.parse(plateData[index]["amount"]);

                  return InkWell(
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
                                Text('      Time In : ${plateData[index]["dateTimein"]}',style: TextStyle(fontSize: 17.0),),
                                Text('      Time Out : ${plateData[index]["dateTimeout"]}',style: TextStyle(fontSize: 17.0),),
                                Text('      Entrance Fee : '+oCcy.format(int.parse(plateData[index]["amount"])),style: TextStyle(fontSize: 17.0),),
                                Text('      Penalty : '+oCcy.format(int.parse(plateData[index]["penalty"])),style: TextStyle(fontSize: 17.0),),
                                Text('      Cut-off Violation : '+oCcy.format(int.parse(plateData[index]["cutOffviolation"])),style: TextStyle(fontSize: 17.0),),
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