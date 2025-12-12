class UserModel {
  int? userID;
  String? name;
  String? business;
  String? email;
  String? phone;
  String? location;
  String? password;
  String? pinCode;
  int? isLoggedIn; 

  UserModel({
    this.userID,
    required this.name,
    required this.business,
    required this.email,
    required this.phone,
    required this.location,
    required this.password,
     this.pinCode,
    this.isLoggedIn = 0, 
  });
 UserModel copyWith({
  int? id,
  String? name,
  String? email,
  String? pinCode,
  String? business,
  String? password,
  String? location,
  String? phone,
  int? isLoggedIn,
  int? userID,
}) {
  return UserModel(
    userID: id ?? this.userID,
    name: name ?? this.name,
    email: email ?? this.email,
    pinCode: pinCode ?? this.pinCode,
    business: business ?? this.business,
    password: password ?? this.password,
    location: location ?? this.location,
    phone: phone ?? this.phone,
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    
  );
}
  UserModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    business = json['business'];
    email = json['email'];
    phone = json['phone'];
    location = json['location'];
    password = json['password'];
    pinCode = json['pinCode'];
    isLoggedIn = json['isLoggedIn'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['name'] = name;
    data['business'] = business;
    data['email'] = email;
    data['phone'] = phone;
    data['location'] = location;
    data['password'] = password;
    data['pinCode'] = pinCode;
    data['isLoggedIn'] = isLoggedIn ?? 0;
    return data;
  }
}
