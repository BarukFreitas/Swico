import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swico/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final Function(MatchResult) onResultSelected;

  const MatchCard({
    super.key,
    required this.match,
    required this.onResultSelected,
  });

  String _getResultText(MatchResult result) {
    switch (result) {
      case MatchResult.player1Wins:
        return '${match.player1.name} Vence';
      case MatchResult.player2Wins:
        return '${match.player2.name} Vence';
      case MatchResult.draw:
        return 'Empate';
      case MatchResult.notPlayed:
        return 'Não jogado';
    }
  }

  Color _getResultColor(MatchResult result) {
    switch (result) {
      case MatchResult.player1Wins:
      case MatchResult.player2Wins:
        return Colors.green.shade700;
      case MatchResult.draw:
        return Colors.blue.shade700;
      case MatchResult.notPlayed:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    match.player1.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'vs.',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                Expanded(
                  child: Text(
                    match.player2.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getResultColor(match.result).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Resultado: ${_getResultText(match.result)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _getResultColor(match.result),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultButton(
                  context,
                  label: '${match.player1.name} Vence',
                  result: MatchResult.player1Wins,
                  isSelected: match.result == MatchResult.player1Wins,
                ),
                _buildResultButton(
                  context,
                  label: 'Empate',
                  result: MatchResult.draw,
                  isSelected: match.result == MatchResult.draw,
                ),
                _buildResultButton(
                  context,
                  label: '${match.player2.name} Vence',
                  result: MatchResult.player2Wins,
                  isSelected: match.result == MatchResult.player2Wins,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultButton(
      BuildContext context, {
      required String label,
      required MatchResult result,
      required bool isSelected,
    }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => onResultSelected(result),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}