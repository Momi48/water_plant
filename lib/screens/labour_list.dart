import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/labour_model.dart';
import 'package:water_plant/screens/consumer_info.dart';
import 'package:water_plant/screens/edit_labour_info.dart';
import 'package:water_plant/screens/labour_info.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/rich_text.dart';

class LabourList extends StatefulWidget {
  const LabourList({super.key});

  @override
  State<LabourList> createState() => _LabourListState();
}

class _LabourListState extends State<LabourList> {
  TextEditingController searchController = TextEditingController();
  List<LabourModelData> allLabours = [];
  List<LabourModelData> filteredLabours = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(filterConsumers);
  }

  void fetchData() async {
    final labours = await SqfliteServices().fetchLabourInfo();
    setState(() {
      allLabours = labours;
      filteredLabours = labours;
    });
  }

  void filterConsumers() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredLabours = allLabours.where((labour) {
        final name = labour.name?.toLowerCase() ?? '';
        final id = labour.labourId.toString(); // convert int to string

        return name.contains(query) || id.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

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
                  'Labour List',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LabourInfo(),
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
                      FutureBuilder<List<LabourModelData>>(
                        future: SqfliteServices().fetchLabourInfo(),
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
                          return filteredLabours.isEmpty
                              ? Center(child: Text("ID or Name Dosen't Exist "))
                              : ListView.builder(
                                  itemCount: filteredLabours.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final labourData = filteredLabours[index];

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
                                                'CU-31005',
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
                                                          EditLabourInfo(),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit_square,
                                                  size: 17,
                                                ),
                                              ),
                                              SizedBox(width: 9),
                                              Icon(Icons.delete, size: 17),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RichTextLabel(
                                                  title: "Labour Id",
                                                  value: labourData.labourCode
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
                                                    value: labourData.mobile1
                                                        .toString(),
                                                    textAlign: TextAlign
                                                        .left, // also left-aligned
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: RichTextLabel(
                                                  title: "Date of Joining",
                                                  value:
                                                      labourData.dateOfJoining!,

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
                                                title: "Loan Amount",
                                                value:
                                                    "Rs. ${labourData.salary}",
                                              ),

                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: RichTextLabel(
                                                    title: "Monthly Delivery",
                                                    value: "2",
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),

                                              Row(
                                                mainAxisSize: MainAxisSize.min,

                                                children: [
                                                  RichTextLabel(
                                                    title: "Daily Delivery",
                                                    value: "2".toString(),
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
                                                title: labourData.salary == null
                                                    ? "Total Commision"
                                                    : "Monthly Salary",
                                                value:
                                                    "Rs. ${labourData.salary}",
                                              ),
                                              SizedBox(width: 20),
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
                                                      "Loan",
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
                                              SizedBox(width: 10),
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
                                                    child:
                                                        labourData.salary ==
                                                            null
                                                        ? Text('Pay Commision')
                                                        : Text(
                                                            "Pay Salary",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
}
