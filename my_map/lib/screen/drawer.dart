import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Group',
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
            accountEmail: Text(
              'group@gmail.com',
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
            currentAccountPicture: CircleAvatar(
              radius: screenWidth * 0.06,
              backgroundImage: AssetImage('assets/images/saurabh.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.timer, size: screenWidth * 0.07),
            title:
                Text('Timer', style: TextStyle(fontSize: screenWidth * 0.045)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month, size: screenWidth * 0.07),
            title: Text('Attendance',
                style: TextStyle(fontSize: screenWidth * 0.045)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
