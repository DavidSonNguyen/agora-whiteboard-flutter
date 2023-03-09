import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/white_board_joining_model.dart';
import 'package:whiteboard/model/whiteboard_camera_state.dart';

import 'whiteboard_platform.dart';

class Whiteboard extends WhiteBoardPlatform {
  Whiteboard({
    Key? key,
    required String roomUuid,
    required String roomToken,
    required String appIdentifier,
    required String userId,
    String? userName,
    Function(String dir, int index)? onLoadedCurrentScene,
    Function(WhiteBoardRoomPhase roomPhase)? onPhaseChanged,
    Function(WhiteboardCameraState cameraState)? onCameraStateChanged,
    this.width,
    this.height,
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

  final double? width;

  final double? height;

  @override
  State<StatefulWidget> createState() {
    return _WhiteBoardState();
  }
}

class _WhiteBoardState extends State<Whiteboard> {
  final channel = const MethodChannel('whiteboard');

  final _eventChannel = const EventChannel('whiteboard_event_channel');
  late StreamSubscription<dynamic> _sink;

  @override
  void initState() {
    super.initState();
    _sink = _eventChannel.receiveBroadcastStream().listen(_eventListener);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'whiteboard',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'whiteboard',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
      '$defaultTargetPlatform is not yet supported by the webview_flutter plugin',
    );
  }

  void _onPlatformViewCreated(int id) async {
    joinRoom(0);
  }

  void _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onJoinRoomResult':
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
      case 'onLoadedCurrentScene':
        widget.onLoadedCurrentScene?.call(map['dir'], map['index']);
        break;
      case 'onPhaseChanged':
        widget.onPhaseChanged
            ?.call(WhiteboardRoomPhaseConverter.fromString(map['roomPhase']));
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
    }
  }

  void joinRoom(int count) {
    channel.invokeMethod('joinRoom', {
      'uuid': widget.roomUuid,
      'roomToken': widget.roomToken,
      'uid': widget.userId,
      'writable': widget.writable ?? true,
      'mode': widget.viewMode?.name,
      'appIdentifier': widget.appIdentifier,
      'userName': widget.userName ?? '',
      'region': widget.region?.name() ?? '',
      'count': count,
      'disableCameraTransform': true,
    });
  }

  @override
  void dispose() {
    _sink.cancel();
    super.dispose();
  }
}

class _CreationParams {
  _CreationParams();

  static _CreationParams fromWidget(Whiteboard widget) {
    return _CreationParams();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> params = {};
    return params;
  }
}
