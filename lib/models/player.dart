class Player {
  final String name;
  int score;

  Player({
    required this.name,
    this.score = 0
  });

  void addScore(int points) {
    score += points;
  }
}