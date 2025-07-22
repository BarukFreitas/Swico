import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swico/providers/tournament_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swico/widgets/match_card.dart';
import 'package:swico/screens/ranking_screen.dart';

class RoundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TournamentProvider>(
          builder: (context, tournamentProvider, child) {
            return Text('Rodada ${tournamentProvider.currentRound?.roundNumber ?? '-'}');
          },
        ),
        centerTitle: true,
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, tournamentProvider, child) {
          if (tournamentProvider.currentRound == null || tournamentProvider.currentRound!.matches.isEmpty) {
            if (tournamentProvider.completedRounds == tournamentProvider.totalRounds && tournamentProvider.totalRounds > 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 100, color: Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                    Text(
                      'Torneio Finalizado!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Todos os resultados foram registrados.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RankingScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.leaderboard),
                      label: Text('Ver Classificação Final'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        tournamentProvider.endTournament();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Torneio encerrado. Crie um novo!'),
                            backgroundColor: Colors.blueGrey,
                          ),
                        );
                      },
                      child: Text('Novo Torneio'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_esports, size: 80, color: Colors.grey.shade400),
                    SizedBox(height: 10),
                    Text(
                      'Nenhuma partida nesta rodada.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                    ),
                    Text(
                      'Verifique a geração de rodadas ou número de jogadores.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }
          }

          return Column(
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
                          'Partidas da Rodada:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Rodadas: ${tournamentProvider.currentRound!.roundNumber} / ${tournamentProvider.totalRounds}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rodada Completa: ${tournamentProvider.currentRound!.isCompleted ? 'Sim' : 'Não'}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: tournamentProvider.currentRound!.isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tournamentProvider.currentRound!.matches.length,
                  itemBuilder: (context, index) {
                    final match = tournamentProvider.currentRound!.matches[index];
                    return MatchCard(
                      match: match,
                      onResultSelected: (result) {
                        tournamentProvider.registerMatchResult(match, result);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: tournamentProvider.currentRound!.isCompleted
                      ? () {
                          tournamentProvider.advanceToNextRound();
                          if (tournamentProvider.currentRound == null) {
                            if (tournamentProvider.completedRounds == tournamentProvider.totalRounds) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RankingScreen(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Torneio Finalizado!'),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao gerar próxima rodada ou torneio inconcluso.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Rodada ${tournamentProvider.currentRound!.roundNumber} iniciada!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      : null,
                  icon: Icon(Icons.skip_next),
                  label: Text('Próxima Rodada'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: tournamentProvider.currentRound!.isCompleted ? Theme.of(context).primaryColor : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}