// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whiteboard_camera_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WhiteboardCameraState extends WhiteboardCameraState {
  @override
  final double centerX;
  @override
  final double centerY;
  @override
  final double? width;
  @override
  final double? height;
  @override
  final double scale;

  factory _$WhiteboardCameraState(
          [void Function(WhiteboardCameraStateBuilder)? updates]) =>
      (new WhiteboardCameraStateBuilder()..update(updates))._build();

  _$WhiteboardCameraState._(
      {required this.centerX,
      required this.centerY,
      this.width,
      this.height,
      required this.scale})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        centerX, r'WhiteboardCameraState', 'centerX');
    BuiltValueNullFieldError.checkNotNull(
        centerY, r'WhiteboardCameraState', 'centerY');
    BuiltValueNullFieldError.checkNotNull(
        scale, r'WhiteboardCameraState', 'scale');
  }

  @override
  WhiteboardCameraState rebuild(
          void Function(WhiteboardCameraStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WhiteboardCameraStateBuilder toBuilder() =>
      new WhiteboardCameraStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WhiteboardCameraState &&
        centerX == other.centerX &&
        centerY == other.centerY &&
        width == other.width &&
        height == other.height &&
        scale == other.scale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, centerX.hashCode);
    _$hash = $jc(_$hash, centerY.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, scale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WhiteboardCameraState')
          ..add('centerX', centerX)
          ..add('centerY', centerY)
          ..add('width', width)
          ..add('height', height)
          ..add('scale', scale))
        .toString();
  }
}

class WhiteboardCameraStateBuilder
    implements Builder<WhiteboardCameraState, WhiteboardCameraStateBuilder> {
  _$WhiteboardCameraState? _$v;

  double? _centerX;
  double? get centerX => _$this._centerX;
  set centerX(double? centerX) => _$this._centerX = centerX;

  double? _centerY;
  double? get centerY => _$this._centerY;
  set centerY(double? centerY) => _$this._centerY = centerY;

  double? _width;
  double? get width => _$this._width;
  set width(double? width) => _$this._width = width;

  double? _height;
  double? get height => _$this._height;
  set height(double? height) => _$this._height = height;

  double? _scale;
  double? get scale => _$this._scale;
  set scale(double? scale) => _$this._scale = scale;

  WhiteboardCameraStateBuilder();

  WhiteboardCameraStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _centerX = $v.centerX;
      _centerY = $v.centerY;
      _width = $v.width;
      _height = $v.height;
      _scale = $v.scale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WhiteboardCameraState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WhiteboardCameraState;
  }

  @override
  void update(void Function(WhiteboardCameraStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WhiteboardCameraState build() => _build();

  _$WhiteboardCameraState _build() {
    final _$result = _$v ??
        new _$WhiteboardCameraState._(
            centerX: BuiltValueNullFieldError.checkNotNull(
                centerX, r'WhiteboardCameraState', 'centerX'),
            centerY: BuiltValueNullFieldError.checkNotNull(
                centerY, r'WhiteboardCameraState', 'centerY'),
            width: width,
            height: height,
            scale: BuiltValueNullFieldError.checkNotNull(
                scale, r'WhiteboardCameraState', 'scale'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
