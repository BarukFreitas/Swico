import 'package:flutter/material.dart';
import 'package:swico/models/player.dart';
import 'package:swico/models/tournament.dart';
import 'package:swico/models/match.dart';
import 'package:swico/models/round.dart';


class TournamentProvider with ChangeNotifier {
  Tournament? _currentTournament;
  List<Player> _players = [];
  List<Round> _rounds = [];
  Round? _currentRound;

  Tournament? get currentTournament => _currentTournament;
  List<Player> get players => _players;
  List<Round> get rounds => _rounds;
  Round? get currentRound => _currentRound;

  void createNewTournament(String name) {
    _currentTournament = Tournament(name: name, players: []);
    _players = [];
    _rounds = [];
    _currentRound = null; 
    notifyListeners();
  }

  void addPlayer(String name) {
    if (_currentTournament != null) {
      final newPlayer = Player(name: name, score: 0);
      _players.add(newPlayer);
      _players.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    }
  }

  void removePlayer(Player player) {
    if (_currentTournament != null) {
      _players.remove(player);
      notifyListeners();
    }
  }

  void startTournament() {
    if (_currentTournament != null && _players.length >= 2) {
      _rounds = [];
      for (var p in _players) {
        p.score = 0;
      } 

      _currentRound = _generateNextRound();
      if (_currentRound != null) {
        _rounds.add(_currentRound!);
        print('Torneio "${_currentTournament!.name}" iniciado com ${_players.length} jogadores. Primeira rodada gerada.');
      } else {
         print('Não foi possível gerar a primeira rodada.');
      }
      notifyListeners();
    } else {
      print('Não é possível iniciar o torneio. Mínimo de 2 jogadores necessários.');
    }
  }

  Round? _generateNextRound() {
    if (_players.length < 2) return null;

    final int nextRoundNumber = _rounds.length + 1;
    List<Match> newMatches = [];
    List<Player> availablePlayers = List.from(_players);

    availablePlayers.shuffle();
    availablePlayers.sort((a, b) => b.score.compareTo(a.score));

    while (availablePlayers.length >= 2) {
      Player p1 = availablePlayers.removeAt(0);
      Player p2 = availablePlayers.removeAt(0);
      newMatches.add(Match(player1: p1, player2: p2));
    }

    if (availablePlayers.isNotEmpty) {
      print('${availablePlayers.first.name} recebeu um BYE nesta rodada.');
    }

    return Round(roundNumber: nextRoundNumber, matches: newMatches);
  }

  void registerMatchResult(Match match, MatchResult result) {
    match.updateResult(result);

    match.player1.score = 0; 
    match.player2.score = 0;

    if (result == MatchResult.player1Wins) {
      match.player1.addScore(2);
    } else if (result == MatchResult.player2Wins) {
      match.player2.addScore(2);
    } else if (result == MatchResult.draw) {
      match.player1.addScore(1);
      match.player2.addScore(1);
    }

    _currentRound?.checkCompletion();
    notifyListeners();
  }

  void advanceToNextRound() {
    if (_currentRound != null && _currentRound!.isCompleted) {
      _currentRound = _generateNextRound();
      if (_currentRound != null) {
        _rounds.add(_currentRound!);
        print('Próxima rodada gerada: Rodada ${_currentRound!.roundNumber}');
        notifyListeners();
      } else {
        print('Não foi possível gerar a próxima rodada. Torneio pode ter terminado ou erro no pareamento.');
      }
    } else {
      print('A rodada atual não está completa ou não há uma rodada em andamento.');
    }
  }
}