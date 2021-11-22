class Year {
  int id;
  String name;
  DateTime dateStart;
  DateTime dateEnd;
  bool isCurrent;

  Year({required this.id, required this.name, required this.dateStart, 
    required this.dateEnd, required this.isCurrent});

  factory Year.fromJson(Map<String, dynamic> json) {
    var value = json;
    return Year(
      id: value['ID'],
      name: value['Name'],
      dateStart: DateTime.parse(value['DateStart']),
      dateEnd: DateTime.parse(value['DateEnd']),
      isCurrent: value['IsCurrent'],
    );
  }
}