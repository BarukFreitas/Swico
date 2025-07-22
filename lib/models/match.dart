import 'package:swico/models/player.dart';

enum MatchResult {
  player1Wins,
  player2Wins,
  draw,
  notPlayed
}

class Match {
  final Player player1;
  final Player player2;
  MatchResult result;

  Match({
    required this.player1,
    required this.player2,
    this.result = MatchResult.notPlayed
  });

  void updateResult(MatchResult newResult) {
    result = newResult;
  }
}