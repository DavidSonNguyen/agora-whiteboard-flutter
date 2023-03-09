@JS()
library manabie_white_board;

import 'dart:async';
import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/whiteboard_scene_size.dart';

import 'whiteboard_controller_platform.dart';

@JS('joinRoomWhiteboard')
external void jsJoinRoomWhiteboard(
  String uuid,
  String roomToken,
  String userId,
  bool writable,
  String viewMode,
  String appIdentifier,
  String region,
  String? viewId,
  String? userName,
  int count,
  bool disableCameraTransform,
);

@JS('leaveRoom')
external Future<void> _jsLeaveRoom();

@JS('cleanScene')
external Future<void> _jsCleanScene(bool retainPpt);

@JS('disableCameraTransform')
external Future<void> _jsDisableCameraTransform(bool disable);

@JS('disableDeviceInputs')
external Future<void> _jsDisableDeviceInputs(bool disable);

@JS('setPencilColor')
external Future<void> _jsSetPencilColor(int r, int g, int b);

@JS('setViewMode')
external Future<void> _jsSetViewMode(String viewMode);

@JS('switchToolTeaching')
external Future<void> _jsSwitchToolTeaching(String tool);

@JS('insertImageUrl')
external Future<void> _jsInsertImageUrl(String url, int width, int height);

@JS('insertPptUrl')
external Future<void> _jsInsertPptUrl(
  String dir,
  int index,
  String url,
  int? width,
  int? height,
);

@JS('insertMultiPpt')
external Future<void> _jsInsertMultiPpt(
  String dir,
  List<String> urls,
  int index,
  List<int> widths,
  List<int> heights,
);

@JS('jumpToPage')
external Future<void> _jsJumpToPage(String dir, int index);

@JS('jumpToInitPage')
external Future<void> _jsJumpToInitPage();

@JS('removeScene')
external Future<void> _jsRemoveScene(String path);

@JS('moveCamera')
external Future<void> _jsMoveCamera(
  double centerX,
  double centerY,
  double scale,
  String animationMode,
);

@JS('scalePptToFit')
external Future<void> _jsScalePptToFit();

@JS('refreshViewSize')
external Future<void> _jsRefreshViewSize();

@JS('updateScalePpt')
external Future<void> _jsUpdateScalePpt(double scale);

@JS('setStrokeWidth')
external Future<void> _jsSetStrokeWidth(double strokeWidth);

@JS('setTextSize')
external Future<void> _jsSetTextSize(double fontSize);

@JS('undo')
external Future<void> _jsUndo();

@JS('redo')
external Future<void> _jsRedo();

@JS('scenePreview')
external Future<void> _jsScenePreview(
  String dir,
  String sceneName,
  String imagePath,
  String viewId,
);

@JS('setCameraBound')
external Future<void> _jsSetCameraBound(
  double centerX,
  double centerY,
  double minScale,
  double maxScale,
  double width,
  double height,
);

@JS('setWhiteboardViewBackgroundColor')
external Future<void> _jsSetWhiteboardViewBackgroundColor(int r, int g, int b);

@JS('getCurrentSceneSizeWhiteboardAction')
external Future<String> _jsGetCurrentSceneSize();

class WhiteboardController extends WhiteboardControllerPlatform {
  @override
  void joinRoom(
    String roomUuid,
    String roomToken,
    String userId,
    String appIdentifier, {
    bool writable = true,
    ViewMode mode = ViewMode.freedom,
    String userName = '',
    WhiteBoardRegion? region,
    disableCameraTransform = true,
  }) {
    return jsJoinRoomWhiteboard(
      roomUuid,
      roomToken,
      userId,
      writable,
      mode.name,
      appIdentifier,
      region?.name() ?? '',
      null,
      userName,
      0,
      disableCameraTransform,
    );
  }

  @override
  Future<void> cleanScene() {
    return _jsCleanScene(true);
  }

  @override
  Future<void> disableCameraTransform(bool disable) {
    return _jsDisableCameraTransform(disable);
  }

  @override
  Future<void> insertImageUrl(String url, int width, int height) {
    return _jsInsertImageUrl(url, width, height);
  }

  @override
  Future<void> insertPptUrl(
    String url,
    String dir, {
    int? width,
    int? height,
    int index = 0,
  }) {
    return _jsInsertPptUrl('/$dir', index, url, width, height);
  }

  @override
  Future<void> jumpToPage(String dir, int index) {
    return _jsJumpToPage('/$dir', index);
  }

  @override
  Future<void> leaveRoom() {
    return _jsLeaveRoom();
  }

  @override
  Future<void> disableDeviceInputs(bool disable) {
    return _jsDisableDeviceInputs(disable);
  }

  @override
  Future<void> setPencilColor(Color color) async {
    await super.setPencilColor(color);
    return _jsSetPencilColor(color.red, color.green, color.blue);
  }

  @override
  Future<void> setViewMode(ViewMode mode) {
    return _jsSetViewMode(mode.name);
  }

  @override
  Future<void> switchToolTeaching(ToolTeaching tool) async {
    await super.switchToolTeaching(tool);
    return _jsSwitchToolTeaching(tool.name);
  }

  @override
  Future<void> insertMultiPpt(
    String dir,
    List<String> urls,
    int index,
    List<int> widths,
    List<int> heights,
  ) {
    super.insertMultiPpt(dir, urls, index, widths, heights);
    return _jsInsertMultiPpt('/$dir', urls, index, widths, heights);
  }

  @override
  Future<void> jumpToInitPage() {
    return _jsJumpToInitPage();
  }

  @override
  Future<void> removeScene({String path = '/'}) {
    return _jsRemoveScene(path);
  }

  @override
  Future<void> moveCamera(
    double centerX,
    double centerY, {
    required double scale,
    AnimationMode animationMode = AnimationMode.immediately,
  }) {
    return _jsMoveCamera(
      centerX,
      centerY,
      scale,
      animationMode.name,
    );
  }

  @override
  Future<void> scalePptToFit() {
    return _jsScalePptToFit();
  }

  @override
  Future<void> refreshViewSize() {
    return _jsRefreshViewSize();
  }

  @override
  Future<void> updateScalePpt(double scale) async {
    return _jsUpdateScalePpt(scale);
  }

  @override
  Future<void> setStrokeWidth(int strokeWidth) async {
    await super.setStrokeWidth(strokeWidth);
    return _jsSetStrokeWidth(strokeWidth.toDouble());
  }

  @override
  Future<void> setTextSize(int fontSize) async {
    await super.setTextSize(fontSize);
    return _jsSetTextSize(fontSize.toDouble());
  }

  @override
  Future<void> redo() {
    return _jsRedo();
  }

  @override
  Future<void> undo() {
    return _jsUndo();
  }

  @override
  Future<void> scenePreview(String dir, String sceneName, String imagePath) {
    return _jsScenePreview(dir, sceneName, imagePath, previewViewId);
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
    return _jsSetCameraBound(
      centerX,
      centerY,
      minScale,
      maxScale,
      width,
      height,
    );
  }

  @override
  Future<WhiteboardSceneSize?> getCurrentSceneSize() async {
    try {
      final result = await promiseToFuture(_jsGetCurrentSceneSize());
      if (result == null) {
        return null;
      }
      final map = jsonDecode(result);
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
  Future<void> setBackgroundColor(Color color) {
    return _jsSetWhiteboardViewBackgroundColor(
      color.red,
      color.green,
      color.blue,
    );
  }
}
