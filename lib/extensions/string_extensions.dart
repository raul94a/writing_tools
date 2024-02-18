import 'package:writing_tools/constants/constants.dart';

extension MonoSilabusCheck on String {
  bool get isMonoSylable => length == 1;
}

extension CleanString on String {
  String clean() {
    return replaceAll(POINT, IDLE)
        .replaceAll(SLASH, IDLE)
        .replaceAll(COMMA, IDLE)
        .replaceAll(POINT_COMMA, IDLE)
        .replaceAll(OPENING, CLOSING)
        .replaceAll(CLOSING, IDLE)
        .replaceAll(CLOSING_DIALOGS, IDLE)
        .replaceAll(OPEN_DIALOGS, IDLE)
        .replaceAll(ASKING_MARK_OPEN, IDLE)
        .replaceAll(ASKING_MARK_CLOSING, IDLE)
        .replaceAll(N, SPACE)
        .replaceAll(R, SPACE)
        .replaceAll(T, SPACE)
        .trim();
  }
}
