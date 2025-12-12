import 'dart:convert';

class ConsumerModel {
  int? consumerId;
  String? name;
  String? phone1;
  String? phone2;
  String? address;
  int? advance;
  int? price;
  int? bottles;
  int? totalAmount;
  Days? days;

  ConsumerModel({
    this.consumerId,
    required this.name,
    required this.phone1,
    this.phone2 = "",
    required this.address,
    required this.advance,
    required this.price,
    required this.bottles,

    required this.days,
  }) : totalAmount = (advance ?? 0) * (bottles ?? 0) * (price ?? 0);

  ConsumerModel.fromJson(Map<String, dynamic> json) {
    consumerId = json['consumer_id'];
    name = json['name'];
    phone1 = json['phone_1'];
    phone2 = json['phone_2'];
    address = json['address'];
    advance = json['advance'];
    price = json['price'];
    bottles = json['bottles'];
    totalAmount = json['total_amount'];
    days = json['days'] != null ? Days.fromJson(json['days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['consumer_id'] = consumerId;
    data['name'] = name;
    data['phone_1'] = phone1;
    data['phone_2'] = phone2;
    data['address'] = address;
    data['advance'] = advance;
    data['price'] = price;
    data['bottles'] = bottles;
    data['total_amount'] = totalAmount;
    if (days != null) {
      data['days'] = jsonEncode(days);
      print('Data of days ${data['days']}');
    }

    return data;
  }
}

class Days {
  bool? monday;
  bool? tuesday;
  bool? wednesday;
  bool? thursday;
  bool? friday;
  bool? saturday;
  bool? sunday;

  Days({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  Days.fromJson(Map<String, dynamic> json) {
    monday = json['Monday'];
    tuesday = json['Tuesday'];
    wednesday = json['Wednesday'];
    thursday = json['Thursday'];
    friday = json['Friday'];
    saturday = json['Saturday'];
    sunday = json['Sunday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Monday'] = monday;
    data['Tuesday'] = tuesday;
    data['Wednesday'] = wednesday;
    data['Thursday'] = thursday;
    data['Friday'] = friday;
    data['Saturday'] = saturday;
    data['Sunday'] = sunday;
    return data;
  }
}
