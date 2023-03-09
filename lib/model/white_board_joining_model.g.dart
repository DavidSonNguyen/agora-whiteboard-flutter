// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'white_board_joining_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WhiteBoardJoiningModel extends WhiteBoardJoiningModel {
  @override
  final WhiteBoardJoiningStatus status;
  @override
  final int times;
  @override
  final String message;

  factory _$WhiteBoardJoiningModel(
          [void Function(WhiteBoardJoiningModelBuilder)? updates]) =>
      (new WhiteBoardJoiningModelBuilder()..update(updates))._build();

  _$WhiteBoardJoiningModel._(
      {required this.status, required this.times, required this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'WhiteBoardJoiningModel', 'status');
    BuiltValueNullFieldError.checkNotNull(
        times, r'WhiteBoardJoiningModel', 'times');
    BuiltValueNullFieldError.checkNotNull(
        message, r'WhiteBoardJoiningModel', 'message');
  }

  @override
  WhiteBoardJoiningModel rebuild(
          void Function(WhiteBoardJoiningModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WhiteBoardJoiningModelBuilder toBuilder() =>
      new WhiteBoardJoiningModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WhiteBoardJoiningModel &&
        status == other.status &&
        times == other.times &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, times.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WhiteBoardJoiningModel')
          ..add('status', status)
          ..add('times', times)
          ..add('message', message))
        .toString();
  }
}

class WhiteBoardJoiningModelBuilder
    implements Builder<WhiteBoardJoiningModel, WhiteBoardJoiningModelBuilder> {
  _$WhiteBoardJoiningModel? _$v;

  WhiteBoardJoiningStatus? _status;
  WhiteBoardJoiningStatus? get status => _$this._status;
  set status(WhiteBoardJoiningStatus? status) => _$this._status = status;

  int? _times;
  int? get times => _$this._times;
  set times(int? times) => _$this._times = times;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  WhiteBoardJoiningModelBuilder();

  WhiteBoardJoiningModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _times = $v.times;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WhiteBoardJoiningModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WhiteBoardJoiningModel;
  }

  @override
  void update(void Function(WhiteBoardJoiningModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WhiteBoardJoiningModel build() => _build();

  _$WhiteBoardJoiningModel _build() {
    final _$result = _$v ??
        new _$WhiteBoardJoiningModel._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WhiteBoardJoiningModel', 'status'),
            times: BuiltValueNullFieldError.checkNotNull(
                times, r'WhiteBoardJoiningModel', 'times'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'WhiteBoardJoiningModel', 'message'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
