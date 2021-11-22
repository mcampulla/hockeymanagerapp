class Category {
  int id;
  String name;
  String tag;
  bool isenabled;

  Category({required this.id, required this.name, required this.tag, required this.isenabled});

  factory Category.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    return Category(
      id: value['ID'],
      name: value['Name'],
      tag: value['Tag'],
      isenabled: value['IsEnabled'],
    );
  }
}