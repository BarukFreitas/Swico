import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swico/providers/tournament_provider.dart';
import 'package:swico/models/player.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tournamentProvider = Provider.of<TournamentProvider>(context);
    final rankedPlayers = tournamentProvider.currentRanking;

    return Scaffold(
      appBar: AppBar(
        title: Text('Classificação Final'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Vencedores do Torneio',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    if (rankedPlayers.isNotEmpty) ...[
                      _buildPodiumPlayer(context, rankedPlayers, 0, Icons.emoji_events, Colors.amber),
                      if (rankedPlayers.length > 1)
                        _buildPodiumPlayer(context, rankedPlayers, 1, Icons.emoji_events, Colors.grey.shade600), 
                      if (rankedPlayers.length > 2)
                        _buildPodiumPlayer(context, rankedPlayers, 2, Icons.emoji_events, Colors.brown.shade600),
                    ] else
                      Text(
                        'Nenhum jogador para classificar.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: rankedPlayers.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum jogador classificado.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    itemCount: rankedPlayers.length,
                    itemBuilder: (context, index) {
                      final player = rankedPlayers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                            ),
                            radius: 25,
                          ),
                          title: Text(
                            player.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Text(
                            '${player.score} pts',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                tournamentProvider.endTournament();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(Icons.home),
              label: Text('Voltar ao Início'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(BuildContext context, List<Player> players, int index, IconData icon, Color iconColor) {
    if (index >= players.length) return SizedBox.shrink();
    final player = players[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: iconColor),
          SizedBox(width: 10),
          Text(
            '${index + 1}. ${player.name} (${player.score} pts)',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}