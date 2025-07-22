import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swico/providers/tournament_provider.dart';
import 'package:swico/widgets/add_player_dialog.dart';
import 'package:swico/widgets/player_list_title.dart';
import 'package:swico/screens/rounds_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _tournamentNameController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Torneio Suíço'),
        centerTitle: true,
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, tournamentProvider, child) {
          if (tournamentProvider.currentTournament == null) {
            return _buildNewTournamentSection(context, tournamentProvider);
          } else {
            return _buildTournamentDetailsSection(context, tournamentProvider);
          }
        },
      ),
      floatingActionButton: Consumer<TournamentProvider>(
        builder: (context, tournamentProvider, child) {
          if (tournamentProvider.currentTournament != null) {
            return FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPlayerDialog(
                      playerNameController: _playerNameController,
                      onAddPlayer: (name) {
                        tournamentProvider.addPlayer(name);
                      },
                    );
                  },
                );
              },
              label: Text('Adicionar Jogador'),
              icon: Icon(Icons.person_add),
            );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNewTournamentSection(BuildContext context, TournamentProvider tournamentProvider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.emoji_events,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 20),
          Text(
            'Crie seu primeiro torneio!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          TextField(
            controller: _tournamentNameController,
            decoration: InputDecoration(
              labelText: 'Nome do Torneio',
              hintText: 'Ex: Torneio de Xadrez da Cidade',
              prefixIcon: Icon(Icons.text_fields),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_tournamentNameController.text.isNotEmpty) {
                tournamentProvider.createNewTournament(_tournamentNameController.text);
                _tournamentNameController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, insira um nome para o torneio.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            icon: Icon(Icons.add),
            label: Text(
              'Criar Torneio',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentDetailsSection(BuildContext context, TournamentProvider tournamentProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    tournamentProvider.currentTournament!.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jogadores: ${tournamentProvider.players.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  if (tournamentProvider.players.length >= 2)
                    ElevatedButton.icon(
                      onPressed: () {
                        tournamentProvider.startTournament();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RoundsScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Torneio iniciado!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('Iniciar Torneio'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: tournamentProvider.players.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        'Nenhum jogador adicionado ainda.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                      ),
                      Text(
                        'Use o botão "+" para adicionar jogadores.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: tournamentProvider.players.length,
                  itemBuilder: (context, index) {
                    final player = tournamentProvider.players[index];
                    return PlayerListTile(
                      player: player,
                      onRemove: () {
                        tournamentProvider.removePlayer(player);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}