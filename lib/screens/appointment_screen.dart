import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/consumer_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/rich_text.dart';

class AppointmentCardScreen extends StatefulWidget {
  const AppointmentCardScreen({super.key});

  @override
  State<AppointmentCardScreen> createState() => _AppointmentCardScreenState();
}

class _AppointmentCardScreenState extends State<AppointmentCardScreen> {
  late Future<List<ConsumerModel>> consumerFuture;

  @override
  void initState() {
    super.initState();
    consumerFuture = SqfliteServices().fetchConsumerData();
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // Dialog content
          content: SizedBox(
            height: 80, // give some height
            width: 60,
            child: Center(
              child: Text(
                "Please Confirm if this Consumer needs to be delete",
                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Button at the bottom
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // your delete logic here
                },
                child: Text("Delete"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          //background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: backgroundColorPlant,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Consumer Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ONE WHITE CONTAINER
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  // List of items INSIDE the same container
                  child: FutureBuilder<List<ConsumerModel>>(
                    future: consumerFuture,
                    builder: (context, snapshot) {
                      snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Consumer Data Found'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final consumerData = snapshot.data![index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichTextLabel(
                                      title: "Id",
                                      value: consumerData.consumerId.toString(),
                                    ),
                                    RichTextLabel(
                                      title: "Date",
                                      value: "12/9/2025",
                                    ),
                                    RichTextLabel(
                                      title: "Amount",
                                      value: consumerData.price.toString(),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 40),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichTextLabel(
                                      title: "Name",
                                      value: consumerData.name.toString(),
                                    ),
                                    RichTextLabel(
                                      title: "Phone",
                                      value: consumerData.phone1.toString(),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDeleteDialog(context);
                                            print('Hello');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: buttonColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Send/Received',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 8),

                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_outline,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
