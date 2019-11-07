import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'parkingtrans.dart';
import 'parkingTransList.dart';
import 'history.dart';

class HomeT extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomeT> {

  @override
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('Park me',style: TextStyle(
              fontSize: 13.0, // insert your font size here
            ),),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections),
            title: Text('Transactions',style: TextStyle(
              fontSize: 13.0, // insert your font size here
            ),),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.share_up),
            title: Text('History',style: TextStyle(
              fontSize: 13.0, // insert your font size here
            ),),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ParkTrans(),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ParkTransList(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HistoryTransList(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}



