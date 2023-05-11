class ImageModel {
  String? image;
  double? lat;
  double? lng;
  String? folder;
  String? location;

  ImageModel({this.image, this.lat, this.lng, this.folder, this.location});

  ImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    lat = json['lat'] is String ? double.tryParse(json['lat']) : json['lat'];
    lng = json['lng'] is String ? double.tryParse(json['lng']) : json['lng'];
    folder = json['folder'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['lat'] = lat.toString();
    data['lng'] = lng.toString();
    data['folder'] = folder;
    data['location'] = location;
    return data;
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
