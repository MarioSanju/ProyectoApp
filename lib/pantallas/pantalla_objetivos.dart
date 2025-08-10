import 'package:flutter/material.dart';

class PantallaObjetivos extends StatefulWidget {
  const PantallaObjetivos({super.key});

  @override
  State<PantallaObjetivos> createState() => _PantallaObjetivosState();
}

class _PantallaObjetivosState extends State<PantallaObjetivos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla objetivos'),),
    );
  }
}