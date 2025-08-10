


import 'package:flutter/material.dart';
import 'pantalla_ia.dart';
import 'pantalla_perfil.dart';
import 'pantalla_diario.dart';
import 'pantalla_objetivos.dart';
import 'pantalla_meditaciones.dart';
import 'pantalla_libro.dart';
import 'pantalla_informe.dart';
import 'dart:ui';
import '../widgets/tarjeta_contactocero.dart';

class PantallaPlan extends StatefulWidget {
  final String planSeleccionado;

  const PantallaPlan({super.key, required this.planSeleccionado});

  @override
  State<PantallaPlan> createState() => _PantallaPlanState();
}

class _PantallaPlanState extends State<PantallaPlan> {
  int _indiceInferior = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallasInferiores = [
      SubPantallaPlan(
        planSeleccionado: widget.planSeleccionado,
        isPremium: false, // Cambiar según usuario
      ),
      PantallaIA(),
      PantallaPerfil(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: pantallasInferiores[_indiceInferior],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: _indiceInferior,
              onTap: (index) => setState(() => _indiceInferior = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Plan'),
                BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'IA'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubPantallaPlan extends StatefulWidget {
  final String planSeleccionado;
  final bool isPremium;

  const SubPantallaPlan({
    super.key, required this.planSeleccionado, this.isPremium = false,
  });

  @override
  State<SubPantallaPlan> createState() => _SubPantallaPlanState();
}

class _SubPantallaPlanState extends State<SubPantallaPlan> {
  int _indiceSubseccion = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indiceSubseccion);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = widget.isPremium;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagenes/diario.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('Contenido', 0),
                _buildTabButton('Diario emocional', 1),
                _buildTabButton('Informe', 2),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _indiceSubseccion = index;
                  });
                },
                children: [
                  _buildContenido(isPremium),
                  PantallaDiarioEmocional(),
                  _buildInforme(isPremium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String texto, int index) {
    bool activo = _indiceSubseccion == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        setState(() {
          _indiceSubseccion = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texto,
            style: TextStyle(
              color: activo ? Colors.white : Colors.white70,
              fontWeight: activo ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              color: activo ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido(bool isPremium) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        const ZeroContactCard(),
        const SizedBox(height: 16),
        _featureCard(
          title: 'Definir límites personales',
          subtitle: 'Establece metas saludables',
          icon: Icons.checklist_rounded,
          premiumRequired: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PantallaObjetivos()),
            );
          },
        ),
        const SizedBox(height: 16),
        _featureCard(
          title: 'Meditaciones',
          subtitle: 'Encuentra calma y relajación',
          icon: Icons.spa_rounded,
          premiumRequired: true,
          onTap: () {
            if (!isPremium) {
              _mostrarPaywall();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PantallaMeditaciones()),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _featureCard(
          title: 'Olvídale en 30 días',
          subtitle: 'Un viaje hacia la superación',
          icon: Icons.menu_book_rounded,
          premiumRequired: true,
          onTap: () {
            if (!isPremium) {
              _mostrarPaywall();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PantallaLibro()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool premiumRequired,
    required VoidCallback onTap,
  }) {
    final isPremium = widget.isPremium;
    final locked = premiumRequired && !isPremium;

    return Stack(
      children: [
        Material(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.deepOrange, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                  if (locked)
                    const Icon(Icons.lock_rounded, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
        if (locked)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Colors.black12],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInforme(bool isPremium) {
    return isPremium
        ? PantallaInforme()
        : Center(
      child: ElevatedButton(
        onPressed: _mostrarPaywall,
        child: const Text('Desbloquear informe Premium'),
      ),
    );
  }

  void _mostrarPaywall() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reconecta Plus'),
        content: const Text(
            'Desbloquea meditaciones y el programa “Olvídale en 30 días”, '
                'y recibe tu informe semanal por solo 4,99 €/año.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ahora no')),
          ElevatedButton(
              onPressed: () {
                // TODO: flujo de compra
                Navigator.pop(context);
              },
              child: const Text('Desbloquear')),
        ],
      ),
    );
  }
}


