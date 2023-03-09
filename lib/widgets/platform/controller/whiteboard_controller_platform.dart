import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:whiteboard/model/enums.dart';
import 'package:whiteboard/model/white_board_joining_model.dart';
import 'package:whiteboard/model/whiteboard_scene_size.dart';

abstract class WhiteboardControllerPlatform extends ChangeNotifier {
  late String previewViewId;

  ToolTeaching defaultToolTeaching = ToolTeaching.pencil;

  ToolTeaching _selectedTool = ToolTeaching.pencil;

  ToolTeaching _selectedShape = ToolTeaching.rectangle;

  ToolTeaching get selectedTool => _selectedTool;

  ToolTeaching get selectedShape => _selectedShape;

  Color _colorSelected = Colors.green;

  Color get colorSelected => _colorSelected;

  int _strokeSize = 7;

  int get strokeSize => _strokeSize;

  int _textSize = 32;

  int get textSize => _textSize;

  final joiningStatus = ValueNotifier<WhiteBoardJoiningModel>(
    WhiteBoardJoiningModel.create(),
  );

  final joiningTimeOut = ValueNotifier<bool>(false);

  final isUsingZoomIn = ValueNotifier<bool>(false);

  void initViewId(String viewId) {
    previewViewId = viewId;
  }

  void joinRoom(
    String roomUuid,
    String roomToken,
    String userId,
    String appIdentifier, {
    bool writable,
    ViewMode mode = ViewMode.freedom,
    String userName,
    WhiteBoardRegion region,
    disableCameraTransform = true,
  });

  Future<void> leaveRoom();

  Future<void> insertImageUrl(String url, int width, int height);

  Future<void> cleanScene();

  Future<void> switchToolTeaching(ToolTeaching tool) async {
    _selectedTool = tool;
    if ({ToolTeaching.rectangle, ToolTeaching.straight, ToolTeaching.ellipse}
        .contains(tool)) {
      _selectedShape = tool;
    }
    isUsingZoomIn.value = false;
  }

  void switchZoomInTool() {
    _selectedTool = ToolTeaching.zoomIn;
    isUsingZoomIn.value = true;
  }

  Future<void> setViewMode(ViewMode mode);

  Future<void> disableCameraTransform(bool disable);

  Future<void> insertPptUrl(
    String url,
    String dir, {
    int width,
    int height,
    int index = 0,
  });

  Future<void> insertMultiPpt(
    String dir,
    List<String> urls,
    int index,
    List<int> widths,
    List<int> heights,
  ) async {
    assert(
      urls.length == widths.length && urls.length == heights.length,
      'width, height must fit url',
    );
  }

  Future<void> jumpToPage(String dir, int index);

  Future<void> jumpToInitPage();

  Future<void> disableDeviceInputs(bool disable);

  Future<void> setBackgroundColor(Color color);

  Future<void> setPencilColor(Color color) async {
    _colorSelected = color;
  }

  Future<void> setTextSize(int fontSize) async {
    _textSize = fontSize;
  }

  Future<void> setStrokeWidth(int strokeWidth) async {
    _strokeSize = strokeWidth;
  }

  Future<void> removeScene({String path});

  Future<void> undo();

  Future<void> redo();

  Future<void> moveCamera(
    double centerX,
    double centerY, {
    required double scale,
    AnimationMode animationMode,
  });

  Future<void> scalePptToFit();

  Future<void> refreshViewSize();

  void Function(String dir, int index)? onLoadedCurrentScene;

  void Function(bool result, String message)? onJoinRoomResult;

  Future<void> handleOnStopSharePDF() async {
    await jumpToInitPage();
    await cleanScene();
    await switchToolTeaching(defaultToolTeaching);
  }

  /// we need to download image to get the width / height to calculate whiteboard pdf
  /// use DefaultCacheManager to cache file
  Future downloadAndInsertToScene(String url, int index, String path) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    final decodedImage = await decodeImageFromList(file.readAsBytesSync());
    await insertPptUrl(
      url,
      path,
      index: index,
      width: decodedImage.width,
      height: decodedImage.height,
    );
    await scalePptToFit();
  }

  Future<void> updateScalePpt(double scale);

  Future<void> scenePreview(String dir, String sceneName, String imagePath);

  Future<void> setCameraBound(
    double centerX,
    double centerY,
    double width,
    double height,
    double minScale,
    double maxScale,
  );

  Future<WhiteboardSceneSize?> getCurrentSceneSize();
}
