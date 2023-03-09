import 'package:built_value/built_value.dart';

part 'whiteboard_scene_size.g.dart';

abstract class WhiteboardSceneSize
    implements Built<WhiteboardSceneSize, WhiteboardSceneSizeBuilder> {
  WhiteboardSceneSize._();

  double get width;

  double get height;

  factory WhiteboardSceneSize([
    void Function(WhiteboardSceneSizeBuilder) updates,
  ]) = _$WhiteboardSceneSize;

  factory WhiteboardSceneSize.create(double width, double height) {
    return WhiteboardSceneSize(
      (updates) => updates
        ..width = width
        ..height = height,
    );
  }
}
