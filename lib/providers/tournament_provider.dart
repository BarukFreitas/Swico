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
  int _totalRounds = 0;

  Tournament? get currentTournament => _currentTournament;
  List<Player> get players => _players;
  List<Round> get rounds => _rounds;
  Round? get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  int get completedRounds => _rounds.where((r) => r.isCompleted).length;

  void createNewTournament(String name, int totalRounds) {
    _currentTournament = Tournament(name: name, players: []);
    _players = [];
    _rounds = [];
    _currentRound = null;
    _totalRounds = totalRounds;
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
      _players.forEach((p) => p.score = 0); // Zera as pontuações dos jogadores apenas no início do torneio

      if (_rounds.length >= _totalRounds) {
        print('Torneio já atingiu o número máximo de rodadas.');
        return;
      }

      _currentRound = _generateNextRound();
      if (_currentRound != null) {
        _rounds.add(_currentRound!);
        print('Torneio "${_currentTournament!.name}" iniciado com ${_players.length} jogadores. Primeira rodada gerada.');
      } else {
         print('Não foi possível gerar a primeira rodada. Pode ser que não haja jogadores suficientes ou um erro no pareamento inicial.');
      }
      notifyListeners();
    } else {
      print('Não é possível iniciar o torneio. Mínimo de 2 jogadores necessários.');
    }
  }

  Round? _generateNextRound() {
    if (_rounds.length >= _totalRounds) {
      return null;
    }

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
    if (match.result != result) {
        _revertScore(match.player1, match.result);
        _revertScore(match.player2, match.result);

        match.updateResult(result);

        _applyScore(match.player1, match.player2, result);

        _currentRound?.checkCompletion();
        notifyListeners();
    }
  }

  void _revertScore(Player player, MatchResult previousResult) {
      if (previousResult == MatchResult.player1Wins || previousResult == MatchResult.player2Wins) {
          player.score -= 2;
      } else if (previousResult == MatchResult.draw) {
          player.score -= 1;
      }
      if (player.score < 0) player.score = 0;
  }

  void _applyScore(Player player1, Player player2, MatchResult result) {
      if (result == MatchResult.player1Wins) {
          player1.addScore(2);
      } else if (result == MatchResult.player2Wins) {
          player2.addScore(2);
      } else if (result == MatchResult.draw) {
          player1.addScore(1);
          player2.addScore(1);
      }
  }


  void advanceToNextRound() {
    if (_currentRound != null && _currentRound!.isCompleted) {
      if (_rounds.length >= _totalRounds) {
        print('Fim do torneio! Todas as rodadas foram completadas.');
        _currentRound = null;
        notifyListeners();
        return;
      }

      _currentRound = _generateNextRound();
      if (_currentRound != null) {
        _rounds.add(_currentRound!);
        print('Próxima rodada gerada: Rodada ${_currentRound!.roundNumber}');
        notifyListeners();
      } else {
        print('Não foi possível gerar a próxima rodada. Torneio pode ter terminado (sem jogadores ou falha no pareamento).');
        // Se _generateNextRound retornou null e o totalRounds ainda não foi atingido,
        // pode ser por falta de jogadores para parear, efetivamente terminando o torneio
        _currentRound = null; // Garante que o estado seja de "torneio finalizado"
        notifyListeners();
      }
    } else {
      print('A rodada atual não está completa ou não há uma rodada em andamento.');
    }
  }

  List<Player> get currentRanking {
    List<Player> sortedPlayers = List.from(_players);
    sortedPlayers.sort((a, b) => b.score.compareTo(a.score));
    return sortedPlayers;
  }

  void endTournament() {
    _currentTournament = null;
    _players = [];
    _rounds = [];
    _currentRound = null;
    _totalRounds = 0;
    notifyListeners();
  }
}