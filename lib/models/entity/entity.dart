import 'package:httapp/models/remote_path.dart';

/// Base class for all entity types surfaced to the UI.
abstract class EntityData {
  final String id;
  final String name;
  final EntityType type;
  const EntityData({required this.id, required this.name, required this.type});
}
