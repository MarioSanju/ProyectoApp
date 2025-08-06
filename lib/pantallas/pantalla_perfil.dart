import 'package:flutter/material.dart';
import 'pantalla_notificaciones.dart';
import 'pantalla_idioma.dart';
import 'pantalla_cambiarcontraseña.dart';
import 'pantalla_soportetecnico.dart';
import 'pantalla_comentarios.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  Widget buildListTile({
    required IconData icon,
    required Color color,
    required String title,
    String subtitle = "",
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 55,),
        const Text("AJUSTES", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold,fontSize: 18)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              buildListTile(
                icon: Icons.notifications,
                color: Colors.deepOrange,
                title: "Notificaciones",
                subtitle: "Activar o desactivar alertas",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaNotificaciones()),
                  );
                },
              ),
              const Divider(),
              buildListTile(
                icon: Icons.language,
                color: Colors.blue,
                title: "Cambiar idioma",
                subtitle: "Selecciona tu idioma preferido",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaIdioma()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text("CUENTA", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold,fontSize: 18)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              buildListTile(
                icon: Icons.lock_outline,
                color: Colors.teal,
                title: "Cambiar contraseña",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaCambiarContrasena()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text("AYUDA", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              buildListTile(
                icon: Icons.support_agent,
                color: Colors.purple,
                title: "Soporte técnico",
                subtitle: "¿Tienes un problema? Contáctanos",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaSoporteTecnico()),
                  );
                },
              ),
              const Divider(),
              buildListTile(
                icon: Icons.feedback_outlined,
                color: Colors.indigo,
                title: "Enviar comentarios",
                subtitle: "Tu opinión nos ayuda a mejorar",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaComentarios()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

