import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/counter_sale_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/edit_counter_sale_dialog.dart';
import 'package:water_plant/widgets/transaction_rows.dart';

class CounterSale extends StatefulWidget {
  const CounterSale({super.key});

  @override
  State<CounterSale> createState() => _CounterSaleState();
}

class _CounterSaleState extends State<CounterSale> {
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  void refreshCounterSale() {
    setState(() {
      filteredTransactions = SqfliteServices().fetchCounterSale(
        context: context,
      );
    });
  }

  late Future<List<CounterSaleModel>> filteredTransactions;

  @override
  void initState() {
    super.initState();
    filteredTransactions = SqfliteServices().fetchCounterSale(context: context);
  }
 Future<void> pickDate(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime now = DateTime.now();

  DateTime initialDate = now;

  if (controller.text.isNotEmpty) {
    try {
      final parts = controller.text.split('-');
      initialDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {}
  }

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    controller.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
  }
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
                              showEditCounterSaleDialog(
                                context,
                                refreshCounterSale,
                                 
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
                          FutureBuilder(
                            future: filteredTransactions,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data == null) {
                                return CircularProgressIndicator.adaptive();
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final item = snapshot.data![index];
                                  return TransactionRows(
                                    amount: item.amount!,
                                    date: item.date!,
                                    onEdit: () async {
                                      showEditCounterSaleDialog(context, () {
                                        refreshCounterSale();
                                        
                                      }, 
                                      
                                      item);
                                    },
                                    onDelete: () async {
                                      await SqfliteServices()
                                          .softDeleteCounterSale(
                                            context,
                                            snapshot.data![index].id!,
                                          );
                                      print(
                                        'Data Deleted and status ${snapshot.data![index].status}',
                                      );
                                      refreshCounterSale();
                                    },
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
