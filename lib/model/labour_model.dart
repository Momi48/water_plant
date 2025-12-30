class LabourModelData {
  int? labourId;
  String? labourCode;
  String? name;
  String? cnic;
  String? mobile1;
  String? mobile2;
  String? address;
  String? dateOfJoining;
  String? jobType;
  int? salary;

  LabourModelData({
    this.labourId,
    this.labourCode,
    required this.name,
    required this.cnic,
    required this.mobile1,
    this.mobile2,
    this.address,
    required this.dateOfJoining,
    this.jobType,
    this.salary,
  });

  LabourModelData.fromJson(Map<String, dynamic> json) {
    labourId = json['labour_id'];
    labourCode = json['labour_code'];
    name = json['name'];
    cnic = json['cnic'];
    mobile1 = json['mobile_1'];
    mobile2 = json['mobile_2'];
    address = json['address'];
    dateOfJoining = json['date_of_joining'];
    jobType = json['job_type'];
    salary = json['salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labour_id'] = labourId;
    data['labour_code'] = labourCode;
    data['name'] = name;
    data['cnic'] = cnic;
    data['mobile_1'] = mobile1;
    data['mobile_2'] = mobile2;
    data['address'] = address;
    data['date_of_joining'] = dateOfJoining;
    data['job_type'] = jobType;
    data['salary'] = salary;
    return data;
  }
}
