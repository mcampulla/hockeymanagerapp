class TeamChart {
  int id = 0;
  String name = '';
  String icon = '';
  int point = 0;
  int win = 0;
  int winot =  0;
  int loss = 0;
  int lossot = 0;
  int draw = 0;
  int goalfor = 0;
  int goalagainst = 0;
  int goaldiff = 0;
  int played = 0;

  TeamChart();
  TeamChart.init(this.name, this.point, this.goalfor, this.goalagainst);
}

class PlayerChart {
  int id = 0;
  String name = '';
  String icon = '';
  int played = 0;
  int goal = 0;
  int assist = 0;
  int point = 0;
  int shootin = 0;
  int shootout = 0;
  int faceoffwon = 0;
  int faceofflost = 0;
  int puckwon = 0;
  int pucklost = 0;
  int penalty = 0;
  int penaltywon = 0;
  int plus = 0;
  int minus = 0;

  PlayerChart();
}