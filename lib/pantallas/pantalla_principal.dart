import 'package:flutter/material.dart';
import 'pantalla_login.dart';
import 'pantalla_registro.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Hacemos el fondo transparente
        appBar: AppBar(
          title: const Text('Rompe Corazones'),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Transparente para mostrar degradado
          elevation: 0, // Sin sombra para que no tape el fondo
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Que no ocupe toda la pantalla verticalmente
            children: [
              const Icon(
                Icons.favorite,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Rompe Corazones App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto en blanco para contraste
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaLogin()),
                  );
                },
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaRegistro()),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}