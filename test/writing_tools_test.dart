// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

const TRIGGER_STREAM_READER_MODE = 65526;
const TRIGGER_MULTI_STREAM_READER_MODE = 1048576;
const SPACE = ' ';
const COMMA = ',';
const POINT_COMMA = ';';
const POINT = '.';
const SLASH = '—';
const OPENING = '«';
const CLOSING = '»';
const IDLE = '';
const N = '\n';
const T = '\t';
const R = '\r';
const CONTRACTION = "'";
const OPEN_DIALOGS = "”";
const CLOSING_DIALOGS = '“';
const ASKING_MARK_OPEN = "¿";
const ASKING_MARK_CLOSING = "?";

extension MonoSilabusCheck on String {
  bool get isMonoSylable => length == 1;
}

extension BubbleSorting on List<WordStat> {
  List<WordStat> bubbleSort() {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      for (var j = i + 1; j < length; j++) {
        WordStat elementA = this[i];
        WordStat elementB = this[j];
        if (elementB.repetitions > elementA.repetitions) {
          this[i] = elementB;
          this[j] = elementA;
        }
      }
    }
    return this;
  }
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

typedef WordCounterRegistry = Map<String, int>;

class WordStat {
  final int repetitions;
  final String word;
  const WordStat(this.repetitions, this.word);

  @override
  String toString() => 'WordStat(repetitions: $repetitions, word: $word)';
}

class ReadStats {
  //constructor
  ReadStats();

  //atributos
  int _textLength = 0;
  int _totalWords = 0;
  final WordCounterRegistry _wordCounterRegistry = {};

  //getters

  int get textLength => _textLength;
  int get totalWords => _totalWords;
  WordCounterRegistry get registry => _wordCounterRegistry;

  // methods
  void registerWord(String word) {
    _wordCounterRegistry.update(
      word,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  void setTotalWords(int length) => _totalWords = length;
  void setTextLength(int length) => _textLength = length;

  List<WordStat> getMostRepeated(int amount) {
    final registry = {..._wordCounterRegistry};
    var wordStats = <WordStat>[];
    for (final entry in registry.entries) {
      wordStats.add(WordStat(entry.value, entry.key));
    }
    wordStats = wordStats.bubbleSort();
    if (amount > registry.length) {
      return wordStats;
    }
    final sublist = wordStats.sublist(0, amount);
    return sublist;
  }

  WordStat getStatsForWord(String word){
    try{
      final count = registry[word]!;
      return WordStat(count, word);
    }catch(e){
      return WordStat(0, word);
    }
  }
}

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
    final file = File(path);

    int totalWords = 0;

    final length = file.lengthSync();
    readStats.setTextLength(length);

    final stream = file.openRead();
    await for (final data in stream) {
      final encoding = Utf8Decoder(allowMalformed: true);
      final decodedBytes = encoding.convert(data);
      String string = decodedBytes;
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

void main() {
  group('Text Stats tests', () {
    test('use test.txt file with know words', () async {
      final path = 'test/test.txt';
      final textAnalyzer = TextAnalyzer(path);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;
      print(totalWords);
      print(wordMap);
      print(readStats.getMostRepeated(3));
      expect(wordMap['dinero'], 1);
      expect(wordMap['estas'], 2);
    });
    test('use longer text file with known words', () async {
      final path = 'test/test_2.txt';
      final textAnalyzer = TextAnalyzer(path);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;
      print(totalWords);
      print(readStats.getMostRepeated(5));
      expect(wordMap['lorem'], 4);
      expect(wordMap['ipsum'], 4);
      expect(wordMap['it'], 3);

      expect(totalWords, 91);
    });
    test('use longer text file with known words', () async {
      final path = 'test/test_3.txt';
      final textAnalyzer = TextAnalyzer(path);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;

      print(totalWords);
      print(readStats.textLength);
      print(readStats.getMostRepeated(5));
      print(readStats.registry['aliquam']);
      expect(totalWords, 500);
    });

    test('analyze El Camino de los Reyes', () async {
      var path = 'test/test_4.txt';
      path = 'docs/el_camino_reyes_ESP.txt';
      final textAnalyzer = TextAnalyzer(path);
      
      textAnalyzer.excludeMonosilables = false;
      textAnalyzer.minCharactersNeededToRegister = 1;
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      print(totalWords);

      final wordStat = readStats.getStatsForWord('esquirlada');
      print(wordStat);

      final repeated = readStats.getMostRepeated(20);
      print(repeated);
    });

    test('analyze LPDA', () async {
      final path = 'test/test_5.txt';
      final textAnalyzer = TextAnalyzer(path);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;

      print(totalWords);
      print(readStats._wordCounterRegistry.entries.take(20).toList());
    });
  });
}
