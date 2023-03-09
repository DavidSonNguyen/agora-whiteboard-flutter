import 'package:flutter/services.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/whiteboard_scene_size.dart';

import 'whiteboard_controller_platform.dart';

class WhiteboardController extends WhiteboardControllerPlatform {
  final _channel = const MethodChannel('whiteboard');

  // method call
  @override
  Future<bool> joinRoom(
    String roomUuid,
    String roomToken,
    String userId,
    String appIdentifier, {
    bool writable = true,
    ViewMode mode = ViewMode.freedom,
    String userName = '',
    WhiteBoardRegion? region,
    disableCameraTransform = true,
  }) async {
    bool result = await _channel.invokeMethod('joinRoom', {
      'uuid': roomUuid,
      'roomToken': roomToken,
      'uid': userId,
      'writable': writable,
      'mode': mode.name,
      'appIdentifier': appIdentifier,
      'userName': userName,
      'region': region?.name() ?? '',
      'count': 0,
      'disableCameraTransform': disableCameraTransform,
    });
    return result;
  }

  @override
  Future<void> leaveRoom() async {
    return await _channel.invokeMethod('leaveRoom');
  }

  @override
  Future<void> insertImageUrl(String url, int width, int height) async {
    return await _channel.invokeMethod('insertImageUrl', {
      'url': url,
      'width': width,
      'height': height,
    });
  }

  @override
  Future<void> cleanScene() async {
    return await _channel.invokeMethod('cleanScene');
  }

  @override
  Future<void> switchToolTeaching(ToolTeaching tool) async {
    await super.switchToolTeaching(tool);
    return await _channel.invokeMethod(
      'switchToolTeaching',
      {
        'tool': tool.name,
      },
    );
  }

  @override
  Future<void> setViewMode(ViewMode mode) async {
    return await _channel.invokeMethod(
      'setViewMode',
      {'mode': mode.name},
    );
  }

  @override
  Future<void> disableCameraTransform(bool disable) async {
    return await _channel.invokeMethod(
      'disableCameraTransform',
      {'disable': disable},
    );
  }

  @override
  Future<void> insertPptUrl(
    String url,
    String dir, {
    int? width,
    int? height,
    int index = 0,
  }) async {
    return await _channel.invokeMethod(
      'insertPptUrl',
      {
        'url': url,
        'dir': '/$dir',
        'width': width,
        'height': height,
        'index': index,
      },
    );
  }

  @override
  Future<void> jumpToPage(String dir, int index) async {
    return await _channel.invokeMethod('jumpToPage', {
      'dir': '/$dir',
      'index': index,
    });
  }

  @override
  Future<void> disableDeviceInputs(bool disable) async {
    return await _channel
        .invokeMethod('disableDeviceInputs', {"disable": disable});
  }

  @override
  Future<void> setPencilColor(Color color) async {
    await super.setPencilColor(color);
    List<int> listInt = [];
    listInt.add(color.red);
    listInt.add(color.green);
    listInt.add(color.blue);
    return await _channel.invokeMethod('setPencilColor', {"color": listInt});
  }

  @override
  Future<void> insertMultiPpt(
    String dir,
    List<String> urls,
    int index,
    List<int> widths,
    List<int> heights,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> jumpToInitPage() {
    throw UnimplementedError();
  }

  @override
  Future<void> removeScene({String? path}) {
    throw UnimplementedError();
  }

  @override
  Future<void> moveCamera(
    double centerX,
    double centerY, {
    required double scale,
    AnimationMode? animationMode,
  }) async {
    return _channel.invokeMethod(
      'moveCamera',
      {
        'scale': scale,
        'centerX': centerX,
        'centerY': centerY,
      },
    );
  }

  @override
  Future<void> scalePptToFit() async {
    return await _channel.invokeMethod('scalePptToFit');
  }

  @override
  Future<void> refreshViewSize() async {
    return await _channel.invokeMethod('refreshViewSize');
  }

  @override
  Future<void> updateScalePpt(double scale) async {
    await _channel.invokeMethod(
      'updateScalePpt',
      {'scale': scale},
    );
  }

  @override
  Future<void> setStrokeWidth(int strokeWidth) async {
    await super.setStrokeWidth(strokeWidth);
    return await _channel.invokeMethod(
      'setStrokeWidth',
      {'strokeWidth': strokeWidth.toDouble()},
    );
  }

  @override
  Future<void> setTextSize(int fontSize) async {
    await super.setTextSize(fontSize);
    return await _channel
        .invokeMethod('setTextSize', {'fontSize': fontSize.toDouble()});
  }

  @override
  Future<void> redo() async {
    return await _channel.invokeMethod('redo');
  }

  @override
  Future<void> undo() async {
    return await _channel.invokeMethod('undo');
  }

  @override
  Future<void> scenePreview(
    String dir,
    String sceneName,
    String imagePath,
  ) async {
    return await _channel.invokeMethod('getScenePreviewImage', {
      'dir': dir,
      'sceneName': sceneName,
      'imagePath': imagePath,
    });
  }

  @override
  Future<void> setCameraBound(
    double centerX,
    double centerY,
    double width,
    double height,
    double minScale,
    double maxScale,
  ) {
    return _channel.invokeMethod('setCameraBound', {
      'centerX': centerX,
      'centerY': centerY,
      'minScale': minScale,
      'maxScale': maxScale,
      'width': width,
      'height': height,
    });
  }

  @override
  Future<WhiteboardSceneSize?> getCurrentSceneSize() async {
    try {
      final result =
          await _channel.invokeMethod('getCurrentSceneSizeWhiteboardAction');
      if (result == null) {
        return null;
      }

      final Map<dynamic, dynamic> map = result;

      return WhiteboardSceneSize(
        (u) => u
          ..width = double.parse(map['width'].toString())
          ..height = double.parse(map['height'].toString()),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setBackgroundColor(Color color) async {
    List<int> listInt = [];
    listInt.add(color.red);
    listInt.add(color.green);
    listInt.add(color.blue);
    return await _channel.invokeMethod(
      'setWhiteboardViewBackgroundColor',
      {"color": listInt},
    );
  }
}
