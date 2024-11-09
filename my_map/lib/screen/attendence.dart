import 'package:flutter/material.dart';
import 'package:my_map/const/name.dart';
import 'package:my_map/screen/drawer.dart';

class AttendenceScreen extends StatelessWidget {
  const AttendenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "ATTENDANCE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color.fromARGB(255, 22, 56, 227),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: ConstData.name.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCard(index),
                        const Divider(
                          thickness: 1,
                          color: Colors.black,
                        )
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget arrow(String image) {
    return Container(
      height: 30,
      width: 30,
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(image))),
    );
  }

  Widget CustomCard(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              ConstData.name[index],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 150,
            ),
            const Icon(
              Icons.calendar_month,
              size: 28,
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              size: 28,
              Icons.gps_fixed,
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    arrow(ConstData.images[0]),
                    const Text(
                      "9:30 , AM",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
