import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swico/providers/tournament_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swico/widgets/match_card.dart';

class RoundsScreen extends StatelessWidget {
  const RoundsScreen({super.key});

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
                    'Verifique a geração de rodadas.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Fim do torneio ou sem mais rodadas!'),
                                backgroundColor: Colors.blueAccent,
                              ),
                            );
                            Navigator.of(context).pop();
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
                    backgroundColor: tournamentProvider.currentRound!.isCompleted ? Colors.deepPurple : Colors.grey,
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