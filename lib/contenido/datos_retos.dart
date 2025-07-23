
enum TipoReto { texto, video, test }

class Reto {
  final String idPlan;
  final int dia;
  final String titulo;
  final String descripcion;
  final TipoReto tipo;

  final String? mensajePredefinido;   // Texto fijo para tipo texto
  final String? urlVideo;              // URL para tipo video
  final List<String>? preguntas;       // Preguntas para tipo test

  List<int>? respuestasSeleccionadas; // Respuestas marcadas por el usuario en test

  Reto({
    required this.idPlan,
    required this.dia,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    this.mensajePredefinido,
    this.urlVideo,
    this.preguntas,
    this.respuestasSeleccionadas,
  });
}

List<Reto> listaRetos = [
  Reto(
    idPlan: 'Repara la relación',
    dia: 1,
    titulo: 'Mensaje inspirador',
    descripcion: 'Un texto para reflexionar.',
    tipo: TipoReto.texto,
    mensajePredefinido: 'Recuerda respirar profundo y mantener la calma en momentos difíciles.',
  ),

  Reto(
    idPlan: 'Olvídal@ en 30 días',
    dia: 1,
    titulo: 'Video de meditación',
    descripcion: 'Relájate con este video guiado.',
    tipo: TipoReto.video,
    urlVideo: 'assets/videos/meditacion1.mp4',
  ),

  Reto(
    idPlan: 'Sana en 30 días',
    dia: 1,
    titulo: 'Test de ánimo',
    descripcion: 'Selecciona las respuestas que apliquen.',
    tipo: TipoReto.test,
    preguntas: [
      '¿Te sientes más animado hoy?',
      '¿Has dormido bien?',
      '¿Has practicado alguna actividad física?',
    ],
    respuestasSeleccionadas: [],
  ),
];
