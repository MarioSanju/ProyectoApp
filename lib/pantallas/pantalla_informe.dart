import 'package:flutter/material.dart';

class PantallaInforme extends StatefulWidget {
  const PantallaInforme({super.key});

  @override
  State<PantallaInforme> createState() => _PantallaInformeState();
}

class _PantallaInformeState extends State<PantallaInforme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Informe'),),
    );
  }
}