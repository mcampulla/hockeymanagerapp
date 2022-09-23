class Player {
  int id = 0;
  String fisrcode = '';
  String fisrclub = '';
  String lastname = '';
  String firstname = '';
  int stick = 0;
  int role = 0;
  String photo = '';
  String sex = 'M';
  DateTime birthdate = DateTime.now();
  String birthplace = '';
  String phone = '';
  String email = '';
  int type = 0;
  String tag = '';
  String icon = '';
  String address = '';
  String zip = '';
  String city = '';
  String region = '';
  String country = '';
  bool isactive = false;

  Player();
  Player.init({required this.id, required this.fisrcode, required this.fisrclub, required this.lastname, 
    required this.firstname, required this.birthdate, required this.role, required this.photo,
    required this.isactive});

  factory Player.fromJson(Map<String, dynamic> json) {
    var value = json;
    Player match = Player.init(  
      id: value['ID'],
      fisrcode: value['FisrCode'] ?? '',
      fisrclub: value['FisrClub'] ?? '', 
      lastname: value['LastName'],
      firstname: value['FirstName'],
      birthdate: DateTime.parse(value['BirthDate']),
      //stick: value['Stick'],
      role: value['Role'],
      photo: value['Photo'] ?? '',
      isactive: value['IsActive']
    );
    return match;
  }
}

