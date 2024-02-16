import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

const TRIGGER_STREAM_READER_MODE = 65526;
const TRIGGER_MULTI_STREAM_READER_MODE = 1048576;
const SPACE = ' ';
const POINT = '.';
const SLASH = '—';
const OPENING = '«';
const CLOSING = '»';
const IDLE = '';

extension CleanString on String {
  String clean() {
    return replaceAll(POINT, IDLE)
        .replaceAll(SLASH, IDLE)
        .replaceAll(OPENING, CLOSING)
        .replaceAll(CLOSING, IDLE);
  }
}

void main() {
  test('calculate', () async {
    var totalWords = 0;
    var readLength = 0;
    final wordMap = <String, int>{};

    final path = 'test/test.txt';

    final file = File(path);

    final length = file.lengthSync();
    print(length);


    final stream = file.openRead();
    await for (final data in stream) {
      readLength += data.length;
      print(readLength);

      String string = String.fromCharCodes(data);
      //process
      final spaces = string.allMatches(SPACE);
      totalWords += (spaces.length + 1);
      string = string.clean();
      final split = string.split(SPACE);
      for (final word in split) {
        wordMap.update(
          word,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      print(totalWords);
      print(wordMap);
      expect(wordMap['dinero'], 1);
      expect(wordMap['estas'], 2);
    }
  });
}
