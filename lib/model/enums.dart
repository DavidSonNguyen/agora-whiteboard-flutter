enum ViewMode {
  freedom,
  follower,
  broadcaster,
}

extension ViewModeExtension on ViewMode {
  String get name {
    switch (this) {
      case ViewMode.freedom:
        return 'freedom';
      case ViewMode.follower:
        return 'follower';
      case ViewMode.broadcaster:
        return 'broadcaster';
    }
  }
}

enum WhiteBoardJoiningStatus {
  idle,
  started,
  loading,
  success,
  error,
}

enum WhiteBoardRoomPhase {
  none,
  connected,
  connecting,
  disconnected,
  disconnecting,
  reconnecting,
}

extension WhiteboardRoomPhaseExtension on WhiteBoardRoomPhase {
  String get name {
    switch (this) {
      case WhiteBoardRoomPhase.connected:
        return 'connected';
      case WhiteBoardRoomPhase.connecting:
        return 'connecting';
      case WhiteBoardRoomPhase.disconnected:
        return 'disconnected';
      case WhiteBoardRoomPhase.disconnecting:
        return 'disconnecting';
      case WhiteBoardRoomPhase.reconnecting:
        return 'reconnecting';
      default:
        return 'none';
    }
  }
}

class WhiteboardRoomPhaseConverter {
  static WhiteBoardRoomPhase fromString(String tool) {
    switch (tool) {
      case 'connected':
        return WhiteBoardRoomPhase.connected;
      case 'connecting':
        return WhiteBoardRoomPhase.connecting;
      case 'disconnected':
        return WhiteBoardRoomPhase.disconnected;
      case 'disconnecting':
        return WhiteBoardRoomPhase.disconnecting;
      case 'reconnecting':
        return WhiteBoardRoomPhase.reconnecting;
      default:
        return WhiteBoardRoomPhase.none;
    }
  }
}

enum ToolTeaching {
  selector,
  pencil,
  straight,
  rectangle,
  ellipse,
  eraser,
  text,
  laserPointer,
  hand,
  zoomIn,
  none,
}

extension ToolTeachingExtension on ToolTeaching {
  String get name {
    switch (this) {
      case ToolTeaching.selector:
        return 'selector';
      case ToolTeaching.pencil:
        return 'pencil';
      case ToolTeaching.straight:
        return 'straight';
      case ToolTeaching.rectangle:
        return 'rectangle';
      case ToolTeaching.ellipse:
        return 'ellipse';
      case ToolTeaching.eraser:
        return 'eraser';
      case ToolTeaching.text:
        return 'text';
      case ToolTeaching.laserPointer:
        return 'laserPointer';
      case ToolTeaching.hand:
        return 'hand';
      case ToolTeaching.zoomIn:
        return 'zoomIn';
      case ToolTeaching.none:
        return '';
    }
  }
}

class ToolTeachingConverter {
  static ToolTeaching fromString(String tool) {
    switch (tool) {
      case 'selector':
        return ToolTeaching.selector;
      case 'pencil':
        return ToolTeaching.pencil;
      case 'straight':
        return ToolTeaching.straight;
      case 'rectangle':
        return ToolTeaching.rectangle;
      case 'ellipse':
        return ToolTeaching.ellipse;
      case 'eraser':
        return ToolTeaching.eraser;
      case 'text':
        return ToolTeaching.text;
      case 'laserPointer':
        return ToolTeaching.laserPointer;
      case 'hand':
        return ToolTeaching.hand;
      case 'zoomIn':
        return ToolTeaching.zoomIn;
    }
    return ToolTeaching.none;
  }
}

enum WhiteBoardRegion {
  cnhz,
  ussv,
  inmum,
  sg,
  gblon,
}

extension WhiteBoardRegionExtension on WhiteBoardRegion {
  String name() {
    switch (this) {
      case WhiteBoardRegion.cnhz:
        return 'cn-hz';
      case WhiteBoardRegion.ussv:
        return 'us-sv';
      case WhiteBoardRegion.inmum:
        return 'in-mum';
      case WhiteBoardRegion.sg:
        return 'sg';
      case WhiteBoardRegion.gblon:
        return 'gb-lon';
    }
  }
}

enum AnimationMode {
  immediately,
  continuous,
}

extension AnimationModeExtension on AnimationMode {
  String get name {
    switch (this) {
      case AnimationMode.immediately:
        return 'immediately';
      case AnimationMode.continuous:
        return 'continuous';
    }
    return '';
  }
}
