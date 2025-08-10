
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ZeroContactCard extends StatefulWidget {
  const ZeroContactCard({super.key});

  @override
  State<ZeroContactCard> createState() => _ZeroContactCardState();
}

class _ZeroContactCardState extends State<ZeroContactCard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // -------- Persistencia (Hive) --------
  late final Box _box;

  // Estado persistido
  bool _active = true;
  int _goalDays = 30;
  int _bestStreak = 0;
  DateTime? _startDate; // fecha desde la que corre la racha

  // -------- Animación del anillo --------
  AnimationController? _ctrl;
  Animation<double> _progressAnim = const AlwaysStoppedAnimation(0);

  // -------- Derivados --------
  int get _streakDays {
    if (!_active || _startDate == null) return 0;
    final sd = _startDate!;
    final today = DateTime.now();
    final baseStart = DateTime(sd.year, sd.month, sd.day);
    final baseToday = DateTime(today.year, today.month, today.day);
    return baseToday.difference(baseStart).inDays + 1;
  }

  double get _progress =>
      (_goalDays <= 0) ? 0.0 : (_streakDays / _goalDays).clamp(0.0, 1.0);

  bool get _goalReached => _streakDays >= _goalDays && _active;

  // -------- Ciclo de vida --------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _box = Hive.box('zero_contact');
    _loadFromHive();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animateProgress();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al volver a la app, recalcúlalo por si han pasado días
    if (state == AppLifecycleState.resumed) {
      _loadFromHive();      // por si cambió algo desde fuera
      _animateProgress();   // refresca el anillo al nuevo progreso
      setState(() {});      // repinta con el nuevo _streakDays
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ctrl?.dispose();
    super.dispose();
  }

  // -------- Persistencia --------
  void _loadFromHive() {
    _active     = _box.get('active',     defaultValue: true) as bool;
    _goalDays   = _box.get('goalDays',   defaultValue: 30) as int;
    _bestStreak = _box.get('bestStreak', defaultValue: 0) as int;
    _startDate  = _box.get('startDate') as DateTime?;
  }

  void _saveToHive() {
    _box.put('active', _active);
    _box.put('goalDays', _goalDays);
    _box.put('bestStreak', _bestStreak);
    if (_startDate == null) {
      _box.delete('startDate');
    } else {
      _box.put('startDate', _startDate);
    }
  }

  // -------- Animación --------
  void _animateProgress() {
    if (_ctrl != null) {
      _progressAnim =
          Tween<double>(begin: 0, end: _progress).animate(
            CurvedAnimation(parent: _ctrl!, curve: Curves.easeOutCubic),
          );
      _ctrl!.forward(from: 0);
    } else {
      _progressAnim = AlwaysStoppedAnimation(_progress);
    }
  }

  // -------- Acciones --------
  void _toggleActive() {
    setState(() {
      if (_active) {
        _active = false;
      } else {
        _active = true;
        _startDate ??= DateTime.now(); // si no había, empieza hoy
      }
      _animateProgress();
      _saveToHive();
    });
  }

  Future<void> _registrarContacto() async {
    final ok = await _confirm(
      'He tenido contacto',
      'Esto reiniciará tu racha. ¿Confirmas?',
      acceptText: 'Confirmar',
    );
    if (ok != true) return;

    // Antes de resetear, actualiza bestStreak con la racha real calculada
    final current = _streakDays;
    setState(() {
      if (current > _bestStreak) _bestStreak = current;
      _active = false;
      _startDate = null; // borrar start => racha 0
      _animateProgress();
      _saveToHive();
    });
  }

  Future<void> _editarObjetivo() async {
    final nuevo = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.2),
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (_) => const _GoalPickerSheet(),
    );
    if (nuevo == null) return;
    setState(() {
      _goalDays = nuevo;
      _animateProgress();
      _saveToHive();
    });
  }

  Future<void> _celebrarYElegirSiguientePaso() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _CelebrationDialog(),
    );

    final accion = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.2),
      barrierColor: Colors.black54,
      builder: (_) => _GoalReachedSheet(goalDays: _goalDays),
    );

    if (accion == 'extender') {
      setState(() {
        _goalDays += 15;
        _animateProgress();
        _saveToHive();
      });
    } else if (accion == 'reiniciar') {
      final current = _streakDays;
      setState(() {
        if (current > _bestStreak) _bestStreak = current;
        _active = false;
        _startDate = null;
        _animateProgress();
        _saveToHive();
      });
    }
  }

  Future<bool?> _confirm(String title, String msg, {String acceptText = 'Aceptar'}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(acceptText)),
        ],
      ),
    );
  }

  // -------- UI --------
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _heroDeco(),
          child: Row(
            children: [
              // Anillo animado
              SizedBox(
                height: 92,
                width: 92,
                child: AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (_, __) => Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(92, 92),
                        painter: _RingPainter(
                          progress: _progressAnim.value,
                          background: Colors.white.withOpacity(0.18),
                          foreground: Colors.white,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$_streakDays',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                          const Text('días',
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      if (_goalReached)
                        const Positioned(
                          bottom: -2,
                          child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Texto + acciones
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_moon_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        const Text('Contacto Cero',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        const Spacer(),
                        _pill('$_streakDays/$_goalDays'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _active
                          ? (_goalReached
                          ? '¡Objetivo alcanzado!'
                          : 'Racha activa · Objetivo: $_goalDays días')
                          : (_streakDays > 0
                          ? 'Racha pausada · Llevabas $_streakDays días'
                          : 'Actívalo para empezar tu racha'),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _primaryBtn(
                          onPressed: _toggleActive,
                          icon: _active
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          label: _active ? 'Pausar' : 'Activar',
                        ),
                        _ghostBtn(
                          onPressed: _registrarContacto,
                          icon: Icons.flash_off_rounded,
                          label: 'He tenido contacto',
                        ),
                        _ghostBtn(
                          onPressed: _editarObjetivo,
                          icon: Icons.flag_rounded,
                          label: 'Editar objetivo',
                        ),
                        if (_goalReached)
                          _ghostBtn(
                            onPressed: _celebrarYElegirSiguientePaso,
                            icon: Icons.celebration_rounded,
                            label: 'Siguiente paso',
                          ),
                        if (_bestStreak > 0) // pequeño recordatorio rápido
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text('🥇 Mejor racha: $_bestStreak',
                                style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- helpers UI
  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.22),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
  );

  Widget _primaryBtn({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    );
  }

  Widget _ghostBtn({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white70),
      label: Text(label, style: const TextStyle(color: Colors.white70)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  BoxDecoration _heroDeco() => BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
      colors: [
        const Color(0xFF7B4DFF).withOpacity(0.70),
        const Color(0xFFB75CFF).withOpacity(0.55),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 8)),
    ],
  );
}

/// Painter del anillo
class _RingPainter extends CustomPainter {
  final double progress;
  final Color background;
  final Color foreground;

  _RingPainter({
    required this.progress,
    required this.background,
    required this.foreground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - stroke) / 2;

    final bg = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.white, Colors.white70],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // base
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, 2 * math.pi, false, bg);
    // progreso
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, 2 * math.pi * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

/// BottomSheet para elegir objetivo
class _GoalPickerSheet extends StatelessWidget {
  const _GoalPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [7, 14, 21, 30, 45, 60];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Elegir objetivo de días', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [
                for (final d in opciones)
                  ChoiceChip(
                    label: Text('$d días'),
                    selected: false,
                    onSelected: (_) => Navigator.pop(context, d),
                  ),
                ActionChip(
                  label: const Text('Personalizado'),
                  onPressed: () async {
                    final v = await showDialog<int>(
                      context: context,
                      builder: (_) => const _CustomGoalDialog(),
                    );
                    if (v != null) Navigator.pop(context, v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _CustomGoalDialog extends StatefulWidget {
  const _CustomGoalDialog({super.key});
  @override
  State<_CustomGoalDialog> createState() => _CustomGoalDialogState();
}

class _CustomGoalDialogState extends State<_CustomGoalDialog> {
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Objetivo personalizado'),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Número de días'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            final v = int.tryParse(ctrl.text);
            if (v != null && v > 0) Navigator.pop(context, v);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

/// Diálogo de celebración simple
class _CelebrationDialog extends StatelessWidget {
  const _CelebrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.emoji_events_rounded, size: 48, color: Colors.amber),
            SizedBox(height: 12),
            Text('¡Objetivo alcanzado!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            SizedBox(height: 6),
            Text('Has cumplido tu meta de contacto cero.'),
          ],
        ),
      ),
    );
  }
}

/// Sheet para decidir siguiente paso
class _GoalReachedSheet extends StatelessWidget {
  final int goalDays;
  const _GoalReachedSheet({super.key, required this.goalDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Text('Has completado $goalDays días 👏',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.lock_clock_rounded),
              title: const Text('Mantener contacto cero'),
              subtitle: const Text('Extiende el objetivo 15 días más'),
              onTap: () => Navigator.pop(context, 'extender'),
            ),
            ListTile(
              leading: const Icon(Icons.refresh_rounded),
              title: const Text('Empezar nuevo objetivo'),
              subtitle: const Text('Reinicia la racha desde 0'),
              onTap: () => Navigator.pop(context, 'reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}



