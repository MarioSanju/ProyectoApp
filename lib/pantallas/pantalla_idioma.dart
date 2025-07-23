import 'package:flutter/material.dart';

class PantallaIdioma extends StatefulWidget {
  const PantallaIdioma({super.key});

  @override
  State<PantallaIdioma> createState() => _PantallaIdiomaState();
}

class _PantallaIdiomaState extends State<PantallaIdioma> {
  String idiomaSeleccionado = 'es';

  final Map<String, String> idiomas = {
    'es': 'Español',
    'en': 'English',
    'fr': 'Français',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar idioma')),
      body: ListView(
        children: idiomas.entries.map((entry) {
          return RadioListTile<String>(
            title: Text(entry.value),
            value: entry.key,
            groupValue: idiomaSeleccionado,
            onChanged: (value) {
              setState(() {
                idiomaSeleccionado = value!;
              });

              // Aquí podrías guardar el idioma en almacenamiento local más adelante
              // Ejemplo (futuro): SharedPreferences.setString('idioma', value);
            },
          );
        }).toList(),
      ),
    );
  }
}