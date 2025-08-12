import 'package:flutter/material.dart';
import 'pantallas/pantalla_onboarding.dart';
import 'pantallas/pantalla_plan.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'models/mensaje_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive y abre tus cajas existentes
  await Hive.initFlutter();
  Hive.registerAdapter(MensajeAdapter());
  await Hive.openBox<List>('conversaciones');
  await Hive.openBox<String>('diario_emocional');
  await Hive.openBox('zero_contact');

  // Caja de settings para flags (onboarding, etc.)
  final settingsBox = await Hive.openBox('settingsBox');

  // ⚠️ Solo mientras desarrollas (muestra siempre el onboarding)
  await settingsBox.put('onboarding_visto', false);

  final bool onboardingVisto =
  settingsBox.get('onboarding_visto', defaultValue: false) as bool;

  final bool mostrarOnboarding = !onboardingVisto;

  runApp(RompeCorazonesApp(mostrarOnboarding: mostrarOnboarding));
}

class RompeCorazonesApp extends StatelessWidget {
  const RompeCorazonesApp({super.key, required this.mostrarOnboarding});

  final bool mostrarOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RompeCorazones App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: mostrarOnboarding ? '/onboarding' : '/pantallaplan',

      routes: {
        '/onboarding': (context) => const PantallaOnboarding(),
        '/pantallaplan': (context) => const PantallaPlan(planSeleccionado: 'Sana en 30 días'),
      },
    );
  }
}
