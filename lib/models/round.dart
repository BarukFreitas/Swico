import 'package:swico/models/match.dart';

class Round {
  final int roundNumber;
  final List<Match> matches;
  bool isCompleted;

  Round({
    required this.roundNumber,
    required this.matches,
    this.isCompleted = false
  });

  void checkCompletion() {
    isCompleted = matches.every((match) => match.result != MatchResult.notPlayed);
  }
}