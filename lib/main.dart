import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swico/screens/home_screen.dart';
import 'package:swico/providers/tournament_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneio Suíço',
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Cor principal
        brightness: Brightness.light, // Tema claro
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme( // Usando Google Fonts para o texto
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black87, // Cor do texto principal
          displayColor: Colors.black87, // Cor dos títulos
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
          elevation: 0, // Sem sombra na AppBar
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData( // Corrigido para CardThemeData
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple.shade700, width: 2),
          ),
          labelStyle: GoogleFonts.poppins(color: Colors.deepPurple),
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(
          secondary: Colors.teal, // Adicionado secondary color para o botão "Ver Rodada Atual"
        ),
      ),
      home: HomeScreen(), // Nossa tela inicial
    );
  }
}