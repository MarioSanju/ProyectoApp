import 'package:flutter/material.dart';

class PantallaComentarios extends StatefulWidget {
  const PantallaComentarios({super.key});

  @override
  State<PantallaComentarios> createState() => _PantallaComentariosState();
}

class _PantallaComentariosState extends State<PantallaComentarios> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioController = TextEditingController();

  void enviarComentario() {
    if (_formKey.currentState!.validate()) {
      // Aquí podrías guardar el comentario o enviarlo a un backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu comentario!')),
      );

      comentarioController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar comentarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: comentarioController,
                decoration: const InputDecoration(
                  labelText: 'Escribe tus comentarios aquí',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                value == null || value.isEmpty ? 'El campo no puede estar vacío' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: enviarComentario,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}