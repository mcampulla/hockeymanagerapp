class Year {
  final int id;
  final String name;
  final String dateStart;
  final String dateEnd;
  final bool isCurrent;

  Year({required this.id, required this.name, required this.dateStart, required this.dateEnd, required this.isCurrent});

  factory Year.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    return Year(
      id: value['ID'],
      name: value['Name'],
      dateStart: value['DateStart'],
      dateEnd: value['DateEnd'],
      isCurrent: value['IsCurrent'],
    );
  }
}