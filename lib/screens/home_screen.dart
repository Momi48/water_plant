import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/screens/consumer_list.dart';
import 'package:water_plant/screens/bottle_delivery.dart';
import 'package:water_plant/screens/consumer_info.dart';
import 'package:water_plant/screens/counter_sale.dart';
import 'package:water_plant/screens/labour_list.dart';
import 'package:water_plant/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> pages = [
    ConsumerInfo(),
    CounterSale(),
    BottleDelivery(),
    ConsumerList(),
    LabourList(),
    Settings(),
  ];

  final List<String> _drawerLabels = [
    "Dashboard",
    "Counter Sale",
    "Bottle Delivery",
    "Consumer",
    "Labour",
    "Appointment",
    "Setting"
    
  ];

  void onDrawerTap(int index) {
    if (index < pages.length) {
      setState(() => currentIndex = index);
    } else {
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 3 || currentIndex == 2
          ? null
          : AppBar(
              title: const Text('Personal Information'),
              backgroundColor: backgroundColorPlant,
              iconTheme: const IconThemeData(
                color: Colors.white,
                size: 28,
              ),
              centerTitle: true,
            ),
      drawer: Drawer(
        
        child: Container(
          color: backgroundColorPlant,
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: 50.0, left: 16.0, right: 16.0, bottom: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CircleAvatar(

                      radius: 25,
                      backgroundColor: Colors.white,

                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                     SizedBox(width: 15),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "USERNAME",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "user@gmail.com",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white54,
                  thickness: 1,
                ),
              ),
            Expanded(
  child: Padding(
    padding:  EdgeInsets.only(left: 50),
    child: ListView.builder(
     
      itemCount: _drawerLabels.length,
      itemBuilder: (context, index) {
        final bool isSelected =
            index < pages.length && currentIndex == index;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: GestureDetector(
            onTap: () {
              if (index < pages.length) {
                onDrawerTap(index);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _drawerLabels[index],
                style: TextStyle(
                  color: isSelected ? Colors.yellow : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
),
   Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white54,
                  thickness: 1,
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding:  EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    print("Logout Tapped");
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
     
      body: pages[currentIndex],
    );
  }
}