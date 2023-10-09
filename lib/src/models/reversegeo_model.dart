import 'package:galli_map/src/models/house_model.dart';

class ReverseGeocodingModel {
  String? address;
  String? ward;
  String? district;
  String? province;
  HouseModel? house;
  ReverseGeocodingModel({
    this.address,
    this.house,
    this.ward,
    this.district,
    this.province,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['ward'] = ward;
    data['district'] = district;
    data['province'] = province;
    data['house'] = (house == null) ? null : house!.toJson();
    return data;
  }

  ReverseGeocodingModel.fromJson(Map<String, dynamic> json) {
    address = json['generalName'];
    ward = json['ward'];
    district = json['district'];
    province = json['province'];
    house = json['gallicode'] == null ? null : HouseModel.fromJson(json);
  }
}
