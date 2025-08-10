import 'package:flutter/material.dart';

class PantallaLibro extends StatefulWidget {
  const PantallaLibro({super.key});

  @override
  State<PantallaLibro> createState() => _PantallaLibroState();
}

class _PantallaLibroState extends State<PantallaLibro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla libro'),),
    );
  }
}
