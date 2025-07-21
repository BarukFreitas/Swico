import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlayerDialog extends StatelessWidget {
  final TextEditingController playerNameController;
  final Function(String) onAddPlayer;

  const AddPlayerDialog({
    Key? key,
    required this.playerNameController,
    required this.onAddPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Adicionar Novo Jogador',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: TextField(
        controller: playerNameController,
        decoration: InputDecoration(
          labelText: 'Nome do Jogador',
          hintText: 'Ex: Maria Silva',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        autofocus: true,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            onAddPlayer(value);
            playerNameController.clear();
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            playerNameController.clear();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: GoogleFonts.poppins(color: Colors.redAccent),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (playerNameController.text.isNotEmpty) {
              onAddPlayer(playerNameController.text);
              playerNameController.clear();
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Adicionar',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ],
    );
  }
}