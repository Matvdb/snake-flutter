class Snake{
  static String nom = "";
  static String msgGame = "";

  static int score = 0;

  static bool gameOver = false;

  static List<Case> snakeRow = List.generate(15, (index) => Case("", 0));

  List<List<Case>> snakeBoard = List.generate(15, (index) => List.generate(5, ((index) => Case("", 0))));

  static List<int> snakePosition = [0,1,2];

  static getSnakePositon(){
    return snakePosition;
  }

  static int getScore(){
    return score;
  }
}

class Case{
  var pomme;
  int code = 0;
  Case(this.pomme, this.code);
}