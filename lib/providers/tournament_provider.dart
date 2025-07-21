import 'package:flutter/material.dart';
import 'package:swico/models/player.dart';
import 'package:swico/models/tournament.dart';

class TournamentProvider with ChangeNotifier {
  Tournament? _currentTournament;
  List<Player> _players = [];

  Tournament? get currentTournament => _currentTournament;
  List<Player> get players => _players;

  void createNewTournament(String name) {
    _currentTournament = Tournament(name: name, players: []);
    _players = [];
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
      print('Torneio "${_currentTournament!.name}" iniciado com ${_players.length} jogadores.');
      notifyListeners();
    } else {
      print('Não é possível iniciar o torneio. Mínimo de 2 jogadores necessários.');
    }
  }
}