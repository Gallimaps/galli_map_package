/// A model class that represents a suggestion item for an autocomplete field.
class AutoCompleteModel {
  /// The name of the suggestion item.
  String? name;

  /// The functional class of the suggestion item.

  /// A string representation of the geometry of the suggestion item.
  double? distance;

  /// Creates a new instance of the [AutoCompleteModel] class.
  ///
  /// [name] The name of the suggestion item.

  AutoCompleteModel({this.name, this.distance});

  /// Creates a new instance of the [AutoCompleteModel] class from a JSON map.
  ///
  /// [json] A map containing the properties of the suggestion item.
  AutoCompleteModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    distance = double.parse(json['distance']);
  }

  /// Converts this instance of the [AutoCompleteModel] class to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['distance'] = distance;

    return data;
  }
}
