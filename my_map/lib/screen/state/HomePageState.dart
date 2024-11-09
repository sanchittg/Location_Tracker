import 'package:flutter/material.dart';

import 'package:my_map/screen/HomeScreen.dart';
import 'package:my_map/screen/drawer.dart';
import 'package:my_map/service/UserService.dart';
import 'package:my_map/screen/MapPage.dart';

class HomePageState extends State<HomeScreen> {
  UserService apiService = UserService();
  late Future<List<dynamic>> members;

  @override
  void initState() {
    super.initState();
    members = apiService.users();
  }

  void openMapPage(BuildContext context, dynamic user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'ATTENDANCE',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: members,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found"));
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      Icons.people,
                      size: 32,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "All Members",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Change",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(user['profile_picture']),
                            radius: 25,
                          ),
                          title: GestureDetector(
                            child: Text(
                              '${user['first_name']} ${user['last_name']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () => openMapPage(context, user),
                          ),
                          subtitle: Text(
                            'View Profile',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.gps_fixed,
                            color: Colors.purple,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
