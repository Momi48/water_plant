class CounterSaleModel {
  int? id;
  int? amount;
  String? date;
  int status;

  CounterSaleModel({
    this.id,
    required this.amount,
    required this.date,
    this.status = 0,
  });

  CounterSaleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        date = json['date'],
        status = json['status'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'status': status,
    };
  }
}
