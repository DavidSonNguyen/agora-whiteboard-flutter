@JS()
library manabie_white_board;

import 'dart:async';
import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:uuid/uuid.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/white_board_joining_model.dart';
import 'package:whiteboard/model/whiteboard_camera_state.dart';
import 'package:whiteboard/widgets/platform/controller/whiteboard_controller_web.dart';

import 'whiteboard_platform.dart';

@JS('onEventWhiteboard')
external set _onEvent(void Function(String event, String value) f);

class Whiteboard extends WhiteBoardPlatform {
  Whiteboard({
    Key? key,
    required String roomUuid,
    required String roomToken,
    required String appIdentifier,
    required String userId,
    String? userName,
    Function(String dir, int index)? onLoadedCurrentScene,
    Function(WhiteboardCameraState cameraState)? onCameraStateChanged,
    Function(WhiteBoardRoomPhase roomPhase)? onPhaseChanged,
    Function(WhiteBoardJoiningModel status)? onJoinRoomStatus,
    bool writable = true,
    ViewMode viewMode = ViewMode.freedom,
    Function(ToolTeaching tool)? onToolTeachingChanged,
    WhiteBoardRegion? region,
    Function(bool result, Uint8List imageData, String placeHolder)?
        onGetScenePreviewImage,
    bool disableCameraTransform = true,
  }) : super(
          roomUuid,
          roomToken,
          appIdentifier,
          userId,
          key,
          userName,
          onLoadedCurrentScene,
          onPhaseChanged,
          onCameraStateChanged,
          writable,
          viewMode,
          onToolTeachingChanged,
          region,
          onGetScenePreviewImage,
          onJoinRoomStatus,
          disableCameraTransform,
        );

  @override
  State<StatefulWidget> createState() {
    return _WhiteboardState();
  }
}

class _WhiteboardState extends WhiteboardStatePlatform {
  late html.DivElement _element;
  final _viewId = const Uuid().v4();
  late String _viewType;

  @override
  void initState() {
    _viewType = 'WhiteboardView$_viewId';
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        _element = html.DivElement()
          ..id = _viewId
          ..style.width = '100%'
          ..style.height = '100%';
        return _element;
      },
    );
    _onEvent = allowInterop(_handleOnEventFromJS);
    super.initState();
  }

  void _handleOnEventFromJS(String event, String value) {
    final map = jsonDecode(value);
    switch (event) {
      case 'onLoadedCurrentScene':
        widget.onLoadedCurrentScene?.call(
          map['dir'],
          map['index'],
        );
        break;
      case 'onJoinedResult':
        final status = map['result']
            ? WhiteBoardJoiningStatus.success
            : WhiteBoardJoiningStatus.error;
        widget.onJoinRoomStatus?.call(
          WhiteBoardJoiningModel.create(
            status: status,
            message: map['message'],
            times: map['count'],
          ),
        );
        if (!map['result']) {
          // retry if join room fail
          Timer(const Duration(seconds: 1), () {
            joinRoom(map['count'] + 1);
          });
        }
        break;
      case 'onStartJoin':
        widget.onJoinRoomStatus?.call(
          WhiteBoardJoiningModel.create(
            status: WhiteBoardJoiningStatus.started,
            message: map['message'],
            times: map['count'],
          ),
        );
        break;
      case 'onJoining':
        widget.onJoinRoomStatus?.call(
          WhiteBoardJoiningModel.create(
            status: WhiteBoardJoiningStatus.loading,
            message: map['message'],
            times: map['count'],
          ),
        );
        break;
      case 'onToolTeachingChanged':
        widget.onToolTeachingChanged?.call(
          ToolTeachingConverter.fromString(map['tool']),
        );
        break;
      case 'onPhaseChanged':
        widget.onPhaseChanged?.call(
          WhiteboardRoomPhaseConverter.fromString(map['roomPhase']),
        );
        break;
      case 'onCameraStateChanged':
        final state = WhiteboardCameraState.create(
          map['centerX'],
          map['centerY'],
          map['width'],
          map['height'],
          map['scale'],
        );
        widget.onCameraStateChanged?.call(state);
        break;
      case 'onGetScenePreviewImage':
        final bool result = map['result'];
        final Uint8List imageData = map['imageData'];
        final String placeHolder = map['placeHolder'];
        widget.onGetScenePreviewImage?.call(result, imageData, placeHolder);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: HtmlElementView(
        viewType: _viewType,
        onPlatformViewCreated: (_) {
          joinRoom(0);
        },
      ),
    );
  }

  void joinRoom(int count) {
    jsJoinRoomWhiteboard(
      widget.roomUuid,
      widget.roomToken,
      widget.userId,
      widget.writable!,
      widget.viewMode!.name,
      widget.appIdentifier,
      widget.region?.name() ?? '',
      _viewId,
      widget.userName ?? '',
      count,
      widget.disableCameraTransform!,
    );
  }
}
