import 'package:galli_map/src/models/house_model.dart';

class ReverseGeocodingModel {
  String? address;
  HouseModel? house;
  ReverseGeocodingModel({this.address, this.house});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address!.replaceAll(" ", '');
    data['house'] = (house == null) ? null : house!.toJson();
    return data;
  }

  ReverseGeocodingModel.fromJson(Map<String, dynamic> json) {
    address = json['generalName'];
    house = json['gallicode'] == null ? null : HouseModel.fromJson(json);
  }
}
