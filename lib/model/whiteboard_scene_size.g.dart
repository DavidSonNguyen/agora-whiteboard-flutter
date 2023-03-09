// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whiteboard_scene_size.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WhiteboardSceneSize extends WhiteboardSceneSize {
  @override
  final double width;
  @override
  final double height;

  factory _$WhiteboardSceneSize(
          [void Function(WhiteboardSceneSizeBuilder)? updates]) =>
      (new WhiteboardSceneSizeBuilder()..update(updates))._build();

  _$WhiteboardSceneSize._({required this.width, required this.height})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        width, r'WhiteboardSceneSize', 'width');
    BuiltValueNullFieldError.checkNotNull(
        height, r'WhiteboardSceneSize', 'height');
  }

  @override
  WhiteboardSceneSize rebuild(
          void Function(WhiteboardSceneSizeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WhiteboardSceneSizeBuilder toBuilder() =>
      new WhiteboardSceneSizeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WhiteboardSceneSize &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WhiteboardSceneSize')
          ..add('width', width)
          ..add('height', height))
        .toString();
  }
}

class WhiteboardSceneSizeBuilder
    implements Builder<WhiteboardSceneSize, WhiteboardSceneSizeBuilder> {
  _$WhiteboardSceneSize? _$v;

  double? _width;
  double? get width => _$this._width;
  set width(double? width) => _$this._width = width;

  double? _height;
  double? get height => _$this._height;
  set height(double? height) => _$this._height = height;

  WhiteboardSceneSizeBuilder();

  WhiteboardSceneSizeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _width = $v.width;
      _height = $v.height;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WhiteboardSceneSize other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WhiteboardSceneSize;
  }

  @override
  void update(void Function(WhiteboardSceneSizeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WhiteboardSceneSize build() => _build();

  _$WhiteboardSceneSize _build() {
    final _$result = _$v ??
        new _$WhiteboardSceneSize._(
            width: BuiltValueNullFieldError.checkNotNull(
                width, r'WhiteboardSceneSize', 'width'),
            height: BuiltValueNullFieldError.checkNotNull(
                height, r'WhiteboardSceneSize', 'height'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
