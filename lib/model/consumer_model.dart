class ConsumerModel {
  int? consumerId;
  String? consumerCode;
  String? name;
  String? phone1;
  String? phone2;
  String? address;
  int? advance;
  int? price;
  int? bottles;
  int? totalAmount;
  List<String>? days;

  ConsumerModel({
    this.consumerId,
    this.consumerCode,
    this.name,
    this.phone1,
    this.phone2,
    this.address,
    this.advance,
    this.price,
    this.bottles,
    this.days,
  }) : totalAmount = (advance ?? 0) * (price ?? 0) * (bottles ?? 0);

  ConsumerModel.fromJson(Map<String, dynamic> json) {
    consumerId = json['consumer_id'];
    consumerCode = json['consumer_code'];
    name = json['name'];
    phone1 = json['phone_1'];
    phone2 = json['phone_2'];
    address = json['address'];
    advance = json['advance'];
    price = json['price'];
    bottles = json['bottles'];
    totalAmount = json['total_amount'];
    days = json['days'] != null ? (json['days'] as String).split(',') : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'consumer_id': consumerId,
      'consumer_code': consumerCode,
      'name': name,
      'phone_1': phone1,
      'phone_2': phone2,
      'address': address,
      'advance': advance,
      'price': price,
      'bottles': bottles,
      'total_amount': totalAmount,
      'days': days?.join(','),
    };
  }
}
