class Token {
  final String? accessToken;
  final bool? containerManagement;
  final bool? salesManagement;
  final bool? driverFlag;
  final String? companyId;
  late final String? branchId;

  Token({
    this.accessToken,
    this.containerManagement,
    this.salesManagement,
    this.driverFlag,
    this.companyId,
    this.branchId,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      containerManagement: json['containerManagement'],
      salesManagement: json['salesManagement'],
      driverFlag: json['driverFlag'],
      companyId: json['companyId'].toString(),
      branchId: json['branchId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "containerManagement": containerManagement,
      "salesManagement": salesManagement,
      "driverFlag": driverFlag,
      "companyId": companyId,
      "branchId": branchId
    };
  }
}
