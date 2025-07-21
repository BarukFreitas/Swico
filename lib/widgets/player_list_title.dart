import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swico/models/player.dart';

class PlayerListTile extends StatelessWidget {
  final Player player;
  final VoidCallback onRemove;

  const PlayerListTile({
    Key? key,
    required this.player,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: Theme.of(context).primaryColor),
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
        subtitle: Text(
          'Pontuação: ${player.score}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever, color: Colors.redAccent),
          onPressed: onRemove,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detalhes de ${player.name} (futuro)'),
            ),
          );
        },
      ),
    );
  }
}