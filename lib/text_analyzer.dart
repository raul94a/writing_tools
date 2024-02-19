import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:writing_tools/constants/constants.dart';
import 'package:writing_tools/extensions/string_extensions.dart';
import 'package:writing_tools/read_stats.dart';

class TextAnalyzer {
  // atributos
  final String path;
  bool caseSensitive = false;
  bool excludeMonosilables = false;
  int minCharactersNeededToRegister = 1;
  // constructor
  TextAnalyzer(this.path);
  // métodos
  bool _shouldExcludeWordFromCounting(String word) {
    if (word.isEmpty) {
      return true;
    }
    if (word.isMonoSylable && excludeMonosilables) {
      return true;
    }
    if (word.length < minCharactersNeededToRegister) {
      return true;
    }
    return false;
  }

  Future<ReadStats> analyze() async {
    assert(minCharactersNeededToRegister > 0, '''
      minCharactersNeededToRegister must be greater than 0
    ''');
    final readStats = ReadStats();
    var file = File(path);

    int totalWords = 0;

    final length = file.lengthSync();
    readStats.setTextLength(length);

    final stream = file.openRead();
    await for (var data in stream) {
      final encoding = Utf8Decoder(allowMalformed: true);
      final decodedBytes = encoding.convert(data);
      String string = decodedBytes;
      if (path.contains('.docx')) {
        print('DOCS');
        string = docxToText(Uint8List.fromList(data),handleNumbering: true);
      }
      //process
      string = string.clean();
      final split = string.split(SPACE);
      for (var word in split) {
        if (_shouldExcludeWordFromCounting(word)) {
          continue;
        }
        if (!caseSensitive) {
          word = word.toLowerCase();
        }
        totalWords += 1;
        readStats.registerWord(word);
      }
    }
    readStats.setTotalWords(totalWords);
    return readStats;
  }
}
