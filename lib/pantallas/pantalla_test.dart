import 'package:flutter/material.dart';
import '../contenido/datos_retos.dart';

class PantallaTest extends StatefulWidget {
  final Reto reto;
  const PantallaTest({super.key, required this.reto});

  @override
  State<PantallaTest> createState() => _PantallaTestState();
}

class _PantallaTestState extends State<PantallaTest> {
  late List<bool> respuestasMarcadas;

  @override
  void initState() {
    super.initState();
    respuestasMarcadas = List<bool>.filled(
        widget.reto.preguntas?.length ?? 0, false);
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = widget.reto.preguntas ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.reto.titulo)),
      body: ListView.builder(
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(preguntas[index]),
            value: respuestasMarcadas[index],
            onChanged: (bool? valor) {
              setState(() {
                respuestasMarcadas[index] = valor ?? false;
                // También puedes guardar esta info en el reto, si quieres
                widget.reto.respuestasSeleccionadas = respuestasMarcadas
                    .asMap()
                    .entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes guardar o procesar las respuestas si quieres
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        tooltip: 'Guardar respuestas',
      ),
    );
  }
}