import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/consumer_model.dart';
import 'package:water_plant/screens/consumer_info.dart';
import 'package:water_plant/screens/edit_consumer_info.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/rich_text.dart';

class ConsumerList extends StatefulWidget {
  const ConsumerList({super.key});

  @override
  State<ConsumerList> createState() => _ConsumerListState();
}

class _ConsumerListState extends State<ConsumerList> {
  TextEditingController searchController = TextEditingController();
  List<ConsumerModel> allConsumers = [];
  List<ConsumerModel> filteredConsumers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(filterConsumers);
  }

  void fetchData() async {
    final consumers = await SqfliteServices().fetchConsumerData();
    setState(() {
      allConsumers = consumers;
      filteredConsumers = consumers;
    });
  }

  void filterConsumers() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredConsumers = allConsumers.where((consumer) {
        final name = consumer.name?.toLowerCase() ?? '';
        final id = consumer.consumerId.toString(); // convert int to string

        return name.contains(query) || id.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // SEARCH BAR
                          Expanded(
                            child: SizedBox(
                              height: 40, // match button height
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (value) {
                                  filterConsumers();
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'ID or Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ), // spacing between search and button
                          // ADD NEW BUTTON
                          SizedBox(
                            height: 40, // same as search bar
                            width: 90, // fixed width
                            child: ElevatedButton(
                              onPressed: () {
                                print('Add New pressed');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConsumerInfo(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Add New',
                                style: TextStyle(
                                  color: Colors.white, // better contrast
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      FutureBuilder<List<ConsumerModel>>(
                        future: SqfliteServices().fetchConsumerData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          if (snapshot.data == null) {
                            return Center(
                              child: Text('Consumer Data is Empty'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No Consumer Data Found'),
                            );
                          }
                          return filteredConsumers.isEmpty
                              ? Center(child: Text("ID or Name Dosen't Exist "))
                              : ListView.builder(
                                  itemCount: filteredConsumers.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final consumerData =
                                        filteredConsumers[index];

                                    return Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff5f5f4),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // --- First Row: Consumer Id, Phone, Last Date
                                          Row(
                                            children: [
                                              Text(
                                                consumerData.consumerCode
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.remove_red_eye,
                                                size: 17,
                                              ),
                                              SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditConumserInfo(),
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.edit_square, size: 17)),
                                              SizedBox(width: 9),
                                              Icon(Icons.delete, size: 17),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RichTextLabel(
                                                  title: "Consumer Id",
                                                  value: consumerData.consumerId
                                                      .toString(),
                                                  textAlign: TextAlign
                                                      .left, // left-aligned
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 8.0,
                                                      ),
                                                  child: RichTextLabel(
                                                    title: "Phone",
                                                    value: consumerData.phone1
                                                        .toString(),
                                                    textAlign: TextAlign
                                                        .left, // also left-aligned
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: RichTextLabel(
                                                  title: "Last Date",
                                                  value: "12/9/2025",

                                                  textAlign: TextAlign
                                                      .center, // left-aligned too
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 12),

                                          // --- Second Row: Price, Send Bottle, Icons
                                          Row(
                                            children: [
                                              RichTextLabel(
                                                title: "Price",
                                                value:
                                                    "Rs. ${consumerData.price}",
                                              ),

                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: RichTextLabel(
                                                    title: "Send Bottle",
                                                    value: consumerData
                                                        .consumerId
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),

                                              Row(
                                                mainAxisSize: MainAxisSize.min,

                                                children: [
                                                  RichTextLabel(
                                                    title: "Total Amount",
                                                    value: consumerData.price!
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 12),

                                          // --- Third Row: Total Amount, Received Bottles, Send/Received Button
                                          Row(
                                            children: [
                                              RichTextLabel(
                                                title: "Total Amount",
                                                value:
                                                    "Rs. ${consumerData.consumerId}",
                                              ),
                                              SizedBox(width: 20),
                                              RichTextLabel(
                                                title: "Received Bottles",
                                                value: consumerData.bottles
                                                    .toString(),
                                              ),

                                              Spacer(),

                                              SizedBox(
                                                width: 78,
                                                height: 30,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    print("Send/ pressed");
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(
                                                      0xff207cff,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Send/Recieved",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
}
