import 'package:flutter/material.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  bool notificacionesGenerales = true;
  bool avisosActualizaciones = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Notificaciones generales"),
            subtitle: const Text("Activa o desactiva todas las notificaciones"),
            value: notificacionesGenerales,
            onChanged: (bool value) {
              setState(() {
                notificacionesGenerales = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Avisos de actualizaciones"),
            subtitle: const Text("Recibe alertas cuando haya mejoras importantes"),
            value: avisosActualizaciones,
            onChanged: (bool value) {
              setState(() {
                avisosActualizaciones = value;
              });
            },
          ),
        ],
      ),
    );
  }
}