import 'package:flutter/material.dart';
import 'pantallas/pantalla_login.dart';
import 'pantallas/pantalla_registro.dart';
import 'pantallas/pantalla_principal.dart';
import 'pantallas/pantalla_inicio.dart';

void main() {
  runApp(const RompeCorazonesApp());
}

class RompeCorazonesApp extends StatelessWidget {
  const RompeCorazonesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RompeCorazones App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PantallaPrincipal(),
      routes: {
        '/login': (context) => const PantallaLogin(),
        '/registro': (context) => const PantallaRegistro(),
        '/inicio': (context) => const PantallaInicio(),
      },
    );
  }
}



