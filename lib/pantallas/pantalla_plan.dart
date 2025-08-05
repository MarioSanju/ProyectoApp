
import 'package:flutter/material.dart';
import 'pantalla_ia.dart';
import 'pantalla_perfil.dart';
import '../contenido/datos_retos.dart';
import 'pantalla_video.dart';
import 'pantalla_test.dart';
import 'pantalla_diario.dart';
import 'dart:ui';

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
      SubPantallaPlan(planSeleccionado: widget.planSeleccionado),
      PantallaIA(),
      PantallaPerfil(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: pantallasInferiores[_indiceInferior],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3), // más suave y translúcido
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

  const SubPantallaPlan({super.key, required this.planSeleccionado});

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
    List<Reto> retosFiltrados = listaRetos
        .where((reto) => reto.idPlan == widget.planSeleccionado)
        .toList();
    retosFiltrados.sort((a, b) => a.dia.compareTo(b.dia));

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
            const SizedBox(height: 16),
            Text(
              widget.planSeleccionado,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('Retos diarios', 0),
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
                  _buildRetos(retosFiltrados),
                  PantallaDiarioEmocional(),
                  Center(child: Text('Contenido de Videos Motivacionales', style: TextStyle(color: Colors.white))),
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
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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

  Widget _buildRetos(List<Reto> retos) {
    return ListView.builder(
      itemCount: retos.length,
      itemBuilder: (context, index) {
        final reto = retos[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: Colors.pinkAccent,
              radius: 24,
              child: Text(
                '${reto.dia}°',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            title: Text(
              reto.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                reto.descripcion,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 20, color: Colors.grey[600]),
            onTap: () => _abrirContenidoReto(reto),
          ),
        );
      },
    );
  }

  void _abrirContenidoReto(Reto reto) {
    switch (reto.tipo) {
      case TipoReto.texto:
        _mostrarDialogoTexto(reto);
        break;
      case TipoReto.video:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PantallaVideo(urlVideo: reto.urlVideo ?? ''),
          ),
        );
        break;
      case TipoReto.test:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PantallaTest(reto: reto),
          ),
        );
        break;
    }
  }

  void _mostrarDialogoTexto(Reto reto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reto.titulo),
          content: SingleChildScrollView(
            child: Text(reto.mensajePredefinido ?? ''),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}


