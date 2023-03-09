import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/white_board_joining_model.dart';
import 'package:whiteboard/model/whiteboard_camera_state.dart';

abstract class WhiteBoardPlatform extends StatefulWidget {
  WhiteBoardPlatform(
    this.roomUuid,
    this.roomToken,
    this.appIdentifier,
    this.userId,
    Key? key,
    this.userName,
    this.onLoadedCurrentScene,
    this.onPhaseChanged,
    this.onCameraStateChanged,
    this.writable,
    this.viewMode,
    this.onToolTeachingChanged,
    this.region,
    this.onGetScenePreviewImage,
    this.onJoinRoomStatus,
    this.disableCameraTransform,
  ) : super(key: key) {
    assert(appIdentifier.isNotEmpty, 'appIdentifier can not be empty');
  }

  final String roomUuid;

  final String roomToken;

  final String appIdentifier;

  final String userId;

  final Function(String dir, int index)? onLoadedCurrentScene;

  final Function(WhiteBoardRoomPhase roomPhase)? onPhaseChanged;

  final Function(WhiteboardCameraState cameraState)? onCameraStateChanged;

  final Function(WhiteBoardJoiningModel status)? onJoinRoomStatus;

  final Function(ToolTeaching tool)? onToolTeachingChanged;

  final Function(bool result, Uint8List imageData, String placeHolder)?
      onGetScenePreviewImage;

  final String? userName;

  final bool? writable;

  final ViewMode? viewMode;

  final WhiteBoardRegion? region;

  final bool? disableCameraTransform;
}

abstract class WhiteboardStatePlatform extends State<WhiteBoardPlatform> {}
