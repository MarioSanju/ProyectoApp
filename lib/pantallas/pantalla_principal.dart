/*
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
*/
import 'package:flutter/material.dart';
import 'pantalla_login.dart';
import 'pantalla_registro.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imagenes/diario.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo de la cabeza
                Image.asset(
                  'assets/imagenes/cabezaTransparente.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                // Nombre de la app
                const Text(
                  'Reconecta',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Botón de iniciar sesión
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PantallaLogin()),
                      );
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                ),
                const SizedBox(height: 15),
                // Botón de registrarse
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PantallaRegistro()),
                      );
                    },
                    child: const Text('Registrarse'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
