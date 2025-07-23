import 'package:flutter/material.dart';

class PantallaSoporteTecnico extends StatefulWidget {
  const PantallaSoporteTecnico({super.key});

  @override
  State<PantallaSoporteTecnico> createState() => _PantallaSoportetecnicoState();
}

class _PantallaSoportetecnicoState extends State<PantallaSoporteTecnico> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController mensajeController = TextEditingController();

  void enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica real de envío, como enviar a Firebase, correo, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensaje enviado correctamente')),
      );

      // Limpia los campos después de enviar
      nombreController.clear();
      correoController.clear();
      mensajeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soporte Técnico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese su nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese su correo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mensajeController,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                value == null || value.isEmpty ? 'Escriba su mensaje' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: enviarFormulario,
                child: const Text('Enviar mensaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}