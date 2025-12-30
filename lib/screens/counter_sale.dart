import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/widgets/edit_counter_sale_dialog.dart';
import 'package:water_plant/widgets/transaction_rows.dart';

class CounterSale extends StatefulWidget {
  const CounterSale({super.key});

  @override
  State<CounterSale> createState() => _CounterSaleState();
}

class _CounterSaleState extends State<CounterSale> {
  final searchController = TextEditingController();

  final transactions = [
    {"amount": "Rs. 20,000", "date": "25/9/2025"},
    {"amount": "Rs. 10,000", "date": "26/9/2025"},
  ];

  List<Map<String, String>> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    filteredTransactions = transactions.cast<Map<String, String>>();
    searchController.addListener(_filterTransactions);
  }

  void _filterTransactions() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTransactions = transactions
          .where(
            (tx) =>
                tx["amount"]!.toLowerCase().contains(query) ||
                tx["date"]!.toLowerCase().contains(query),
          )
          .cast<Map<String, String>>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: backgroundColorPlant,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Counter Sale',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // WHITE CONTAINER (Search + Button + Grey data container inside)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // SEARCH FIELD + ADD BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search by amount or date",

                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40, // same as search bar
                          width: 90, // fixed width
                          child: ElevatedButton(
                            onPressed: () {
                              print('Add New pressed');
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

                    const SizedBox(height: 16),

                    // GREY CONTAINER (Transactions)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xffe0e0e0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER ROW
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Amount",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff7C7171),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff7C7171),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Actions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff7C7171),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // LIST OF TRANSACTIONS
                          ListView.builder(
                            itemCount: filteredTransactions.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = filteredTransactions[index];
                              return TransactionRows(
                                amount: item["amount"]!,
                                date: item["date"]!,
                                onEdit: () {
                                  print("Edit ${item["amount"]}");
                                  showEditCounterSaleDialog(context);
                                },
                                onDelete: () {
                                  print("Delete ${item["amount"]}");
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
