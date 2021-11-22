class Club {
  int id;
  String name;
  String tag;
  String icon;

  Club({required this.id, required this.name, required this.tag, required this.icon});

  factory Club.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    return Club(
      id: value['ID'],
      name: value['Name'],
      tag: value['Tag'],
      icon: value['Icon'],
    );
  }
}