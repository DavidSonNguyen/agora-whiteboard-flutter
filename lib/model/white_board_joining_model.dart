import 'package:built_value/built_value.dart';

import 'enums.dart';

part 'white_board_joining_model.g.dart';

abstract class WhiteBoardJoiningModel
    implements Built<WhiteBoardJoiningModel, WhiteBoardJoiningModelBuilder> {
  WhiteBoardJoiningModel._();

  WhiteBoardJoiningStatus get status;

  int get times;

  String get message;

  factory WhiteBoardJoiningModel([
    void Function(WhiteBoardJoiningModelBuilder) updates,
  ]) = _$WhiteBoardJoiningModel;

  factory WhiteBoardJoiningModel.create({
    WhiteBoardJoiningStatus status = WhiteBoardJoiningStatus.idle,
    int? times,
    String? message,
  }) {
    return WhiteBoardJoiningModel(
      (updates) => updates
        ..status = status
        ..times = times ?? 0
        ..message = message ?? '',
    );
  }
}
