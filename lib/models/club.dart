class Club {
  final int id;
  final String name;
  final String tag;
  final String icon;

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