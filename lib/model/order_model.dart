class OrderModel {
  int? id;
  String? nameJob;
  int? statusJob;
  int? idTypeJob;
  String? contentJob;
  String? descriptionJob;
  String? createdAt;
  String? updatedAt;
  int? distance;
  int? estTime;
  String? recipientPhoneNumber;
  String? nameReceiver;
  int? idUser;
  String? startDeliver;
  String? addressJob;
  String? latJob;
  String? longJob;
  int? idWareHouse;
  String? nameType;
  String? nameWareHouse;
  String? addressWareHouse;
  String? latWareHouse;
  String? longWareHouse;

  OrderModel(
      {this.id,
        this.nameJob,
        this.statusJob,
        this.idTypeJob,
        this.contentJob,
        this.descriptionJob,
        this.createdAt,
        this.updatedAt,
        this.distance,
        this.estTime,
        this.recipientPhoneNumber,
        this.nameReceiver,
        this.idUser,
        this.startDeliver,
        this.addressJob,
        this.latJob,
        this.longJob,
        this.idWareHouse,
        this.nameType,
        this.nameWareHouse,
        this.addressWareHouse,
        this.latWareHouse,
        this.longWareHouse});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameJob = json['name_job'];
    statusJob = json['status_job'];
    idTypeJob = json['id_type_job'];
    contentJob = json['content_job'];
    descriptionJob = json['description_job'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    estTime = json['est_time'];
    recipientPhoneNumber = json['recipient_phone_number'];
    nameReceiver = json['name_receiver'];
    idUser = json['id_user'];
    startDeliver = json['start_deliver'];
    addressJob = json['address_job'];
    latJob = json['lat_job'];
    longJob = json['long_job'];
    idWareHouse = json['id_ware_house'];
    nameType = json['name_type'];
    nameWareHouse = json['name_ware_house'];
    addressWareHouse = json['address_ware_house'];
    latWareHouse = json['lat_ware_house'];
    longWareHouse = json['long_ware_house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_job'] = this.nameJob;
    data['status_job'] = this.statusJob;
    data['id_type_job'] = this.idTypeJob;
    data['content_job'] = this.contentJob;
    data['description_job'] = this.descriptionJob;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    data['est_time'] = this.estTime;
    data['recipient_phone_number'] = this.recipientPhoneNumber;
    data['name_receiver'] = this.nameReceiver;
    data['id_user'] = this.idUser;
    data['start_deliver'] = this.startDeliver;
    data['address_job'] = this.addressJob;
    data['lat_job'] = this.latJob;
    data['long_job'] = this.longJob;
    data['id_ware_house'] = this.idWareHouse;
    data['name_type'] = this.nameType;
    data['name_ware_house'] = this.nameWareHouse;
    data['address_ware_house'] = this.addressWareHouse;
    data['lat_ware_house'] = this.latWareHouse;
    data['long_ware_house'] = this.longWareHouse;
    return data;
  }
}
