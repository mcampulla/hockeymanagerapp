class Tournament {
  final int id;
  final String name;
  final int yearid;
  final int categoryid;
  final int periodnumber;
  final int periodlength;
  final int overtimenumber;
  final int overtimelength;
  final int drawpoint;
  final int winpoint;
  final int bonuspoint;
  final int status;

  Tournament({required this.id, required this.name, required this.yearid, required this.categoryid, 
    required this.periodnumber, required this.periodlength, required this.overtimenumber, 
    required this.overtimelength, required this.drawpoint, required this.winpoint, 
    required this.bonuspoint, required this.status});

  factory Tournament.fromJson(Map<String, dynamic> json) {
    var value = json; // json['value'][0];
    return Tournament(
      id: value['ID'],
      name: value['Name'],
      yearid: value['YearID'],
      categoryid: value['CategoryID'],
      periodnumber: value['PeriodNumber'],
      periodlength: value['PeriodLength'],
      overtimenumber: value['OvertimeNumber'],
      overtimelength: value['OvertimeLength'],
      drawpoint: value['DrawPoint'],
      winpoint: value['WinPoint'],
      bonuspoint: value['BonusPoint'],
      status: value['Status']
    );
  }
}