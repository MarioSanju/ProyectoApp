
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/mensaje_model.dart';

class PantallaIA extends StatefulWidget {
  const PantallaIA({super.key});

  @override
  State<PantallaIA> createState() => _PantallaIAState();
}

class _PantallaIAState extends State<PantallaIA> {
  final List<Map<String, String>> mensajes = [];
  final TextEditingController controlador = TextEditingController();
  bool cargando = false;
  String respuestaAnimada = '';

  final String apiKey = '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';

  Future<void> enviarMensaje(String mensaje) async {
    setState(() {
      mensajes.add({'role': 'user', 'content': mensaje});
      cargando = true;
    });

    final respuesta = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            "role": "system",
            "content": "Eres un terapeuta experto en ayudar a personas con el corazón roto."
          },
          ...mensajes.map((m) => {
            "role": m['role'],
            "content": m['content'],
          }),
        ]
      }),
    );

    final data = jsonDecode(utf8.decode(respuesta.bodyBytes));
    final respuestaIA = data['choices'][0]['message']['content'];

    setState(() {
      respuestaAnimada = '';
      mensajes.add({'role': 'assistant', 'content': ''});
      cargando = false;
    });

    await _animarRespuesta(respuestaIA);
    guardarConversacion();
  }

  Future<void> _animarRespuesta(String texto) async {
    for (int i = 0; i < texto.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() {
        respuestaAnimada += texto[i];
        mensajes[mensajes.length - 1]['content'] = respuestaAnimada;
      });
    }
  }

  void guardarConversacion() async {
    final box = Hive.box<List>('conversaciones');
    final clave = DateTime.now().toIso8601String();

    final lista = mensajes
        .map((m) => Mensaje(role: m['role']!, content: m['content']!))
        .toList();
    await box.put(clave, lista);
  }

  void cargarConversacion(List<Mensaje> conversacion) {
    setState(() {
      mensajes.clear();
      mensajes.addAll(conversacion
          .map((m) => {'role': m.role, 'content': m.content})
          .toList());
    });
  }

  void mostrarHistorial() {
    final box = Hive.box<List>('conversaciones');

    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (_) {
        final claves = box.keys.toList().reversed.toList();

        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text('Nueva conversación', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  mensajes.clear();
                });
              },
            ),
            const Divider(height: 0, color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: claves.length,
                itemBuilder: (context, index) {
                  final clave = claves[index];
                  final mensajesGuardados =
                  (box.get(clave) as List).cast<Mensaje>();

                  final primerContenido = mensajesGuardados.isNotEmpty
                      ? mensajesGuardados.first.content
                      : clave.toString();

                  return ListTile(
                    title: Text(
                      primerContenido.length > 32
                          ? '${primerContenido.substring(0, 32)}...'
                          : primerContenido,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    subtitle: Text(
                      clave.toString().substring(0, 19).replaceAll('T', ' '),
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      cargarConversacion(mensajesGuardados);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: Color(0xFF121212), title: Text('solo para crear espacio',style: TextStyle(color: Color(0xFF121212)),),),
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        top: false, // No usamos el padding superior automático
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0), // Ajusta la separación superior
              child: Column(
                children: [
                  Expanded(
                    child: mensajes.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          '¿En qué puedo ayudarte?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: mensajes.length,
                      itemBuilder: (context, index) {
                        final mensaje = mensajes[index];
                        final esUsuario = mensaje['role'] == 'user';

                        return Align(
                          alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: esUsuario
                                ? BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(16),
                            )
                                : null,
                            child: Text(
                              mensaje['content'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                color: esUsuario ? Colors.white : Colors.grey[200],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (cargando)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: controlador,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Escribe algo...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              final texto = controlador.text.trim();
                              if (texto.isNotEmpty) {
                                controlador.clear();
                                enviarMensaje(texto);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: mostrarHistorial,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.history, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
