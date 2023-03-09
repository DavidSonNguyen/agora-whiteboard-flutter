import 'package:built_value/built_value.dart';

part 'whiteboard_camera_state.g.dart';

abstract class WhiteboardCameraState
    implements Built<WhiteboardCameraState, WhiteboardCameraStateBuilder> {
  factory WhiteboardCameraState([
    void Function(WhiteboardCameraStateBuilder) updates,
  ]) = _$WhiteboardCameraState;

  WhiteboardCameraState._();

  factory WhiteboardCameraState.create(
    double centerX,
    double centerY,
    double? width,
    double? height,
    double scale,
  ) {
    return WhiteboardCameraState(
      (updates) => updates
        ..centerX = centerX
        ..centerY = centerY
        ..width = width
        ..height = height
        ..scale = scale,
    );
  }

  double get centerX;

  double get centerY;

  double? get width;

  double? get height;

  double get scale;
}
