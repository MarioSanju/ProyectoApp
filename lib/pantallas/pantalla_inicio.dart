
import 'package:flutter/material.dart';
import 'pantalla_plan.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> with TickerProviderStateMixin {
  int? _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final planes = [
      {
        'id': 'Repara la relación',
        'titulo': 'Repara la relación',
        'descripcion': 'Plan básico para olvidar el amor pasado',
        'color': Colors.blueAccent,
        'imagenFondo': 'assets/imagenes/plan1.png',
      },
      {
        'id': 'Olvídal@ en 30 días',
        'titulo': 'Olvídal@ en 30 días',
        'descripcion': 'Plan intermedio para sanar y crecer',
        'color': Colors.purpleAccent,
        'imagenFondo': 'assets/imagenes/plan2.png',
      },
      {
        'id': 'Sana en 30 días',
        'titulo': 'Sana en 30 días',
        'descripcion': 'Plan avanzado para reinventarte',
        'color': Colors.deepOrangeAccent,
        'imagenFondo': 'assets/imagenes/plan3.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar Plan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: planes.length,
        itemBuilder: (context, index) {
          final plan = planes[index];
          final isExpanded = _expandedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIndex = null;
                } else {
                  _expandedIndex = index;
                }
              });
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: isExpanded ? 280 : 140,
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: plan['color'] as Color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (plan['color'] as Color).withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: plan.containsKey('imagenFondo')
                        ? DecorationImage(
                      image: AssetImage(plan['imagenFondo'] as String),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(isExpanded ? 0.25 : 0.75),
                        BlendMode.darken,
                      ),
                    )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y flecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              plan['titulo'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 5)],
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Nivel
                      Row(
                        children: [
                          const Text(
                            'Nivel: ',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Icon(Icons.flash_on, color: Colors.white, size: 18),
                          if (index > 0) Icon(Icons.flash_on, color: Colors.white, size: 18),
                          if (index > 1) Icon(Icons.flash_on, color: Colors.white, size: 18),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Descripción con padding para evitar overflow
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          plan['descripcion'] as String,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isExpanded ? 14 : 11,
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            splashColor: Colors.white.withOpacity(0.8),
                            highlightColor: Colors.white.withOpacity(0.4),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PantallaPlan(
                                    planSeleccionado: plan['id'] as String,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Empezar día 1',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black87, blurRadius: 2)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


