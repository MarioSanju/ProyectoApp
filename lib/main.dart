
import 'package:flutter/material.dart';
import 'pantallas/pantalla_login.dart';
import 'pantallas/pantalla_registro.dart';
import 'pantallas/pantalla_principal.dart';
import 'pantallas/pantalla_inicio.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'models/mensaje_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive y abre la caja de mensajes
  await Hive.initFlutter();
  Hive.registerAdapter(MensajeAdapter());
  await Hive.openBox<List>('conversaciones');
  await Hive.openBox<String>('diario_emocional');
  runApp(const RompeCorazonesApp());
}

class RompeCorazonesApp extends StatelessWidget {
  const RompeCorazonesApp({super.key});

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



