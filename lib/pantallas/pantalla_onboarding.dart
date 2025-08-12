import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PantallaOnboarding extends StatefulWidget {
  const PantallaOnboarding({super.key});

  @override
  State<PantallaOnboarding> createState() => _PantallaOnboardingState();
}

class _PantallaOnboardingState extends State<PantallaOnboarding> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Bienvenid@ a Reconecta',
      'lines': [
        'Un refugio para sanar el corazón.',
        'Avanza con pasos pequeños, pero firmes.'
      ],
      'cta': 'Continuar'
    },
    {
      'title': 'Qué encontrarás',
      'lines': [
        '• Plan amoroso de 30 días para acompañarte.',
        '• Diario emocional para desahogarte cada día.',
        '• Meditaciones y ejercicios cortos.'
      ],
      'cta': 'Continuar'
    },
    {
      'title': 'Tu voz importa',
      'lines': [
        'Escribe con sinceridad en el Diario y',
        'habla con la IA cuando lo necesites.',
        'Cuanto más auténtico seas, mejor te ayudará.'
      ],
      'cta': 'Continuar'
    },
    {
      'title': 'Informe Premium',
      'lines': [
        'Analizamos tu Diario y conversaciones',
        'para mostrarte progreso, patrones y',
        'recomendaciones personalizadas.'
      ],
      'cta': 'Empezar ahora'
    },
  ];

  void _nextPage() async {
    if (_currentPage == _pages.length - 1) {
      // Guardamos que ya vio el onboarding
      var box = await Hive.openBox('settingsBox');
      await box.put('onboarding_visto', true);

      // Ir al home
      Navigator.pushReplacementNamed(context, '/pantallaplan');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagenes/onboarding_background.png'), // 👈 pon aquí tu fondo
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Páginas
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Título
                    Text(
                      page['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Líneas
                    ...page['lines'].map<Widget>((line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        line,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                        ),
                      ),
                    )),
                    const Spacer(),
                    // Botón
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: Size(size.width * 0.8, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _nextPage,
                      child: Text(page['cta']),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),

          // Indicadores
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
