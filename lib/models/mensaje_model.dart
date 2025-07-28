import 'package:hive/hive.dart';

part 'mensaje_model.g.dart';

@HiveType(typeId: 0)
class Mensaje extends HiveObject {
  @HiveField(0)
  String role;

  @HiveField(1)
  String content;

  Mensaje({required this.role, required this.content});
}
