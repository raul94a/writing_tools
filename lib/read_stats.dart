// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:writing_tools/extensions/word_stat_extensions.dart';

typedef WordCounterRegistry = Map<String, int>;

class WordStat {
  final int repetitions;
  final String word;
  const WordStat(this.repetitions, this.word);

  @override
  String toString() => 'WordStat(repetitions: $repetitions, word: $word)';
}

class PieWordStat extends WordStat {
  final num percentage;
  final int totalWords;
  PieWordStat(super.repetitions, super.word,
      {required this.percentage, required this.totalWords});

  factory PieWordStat.fromWordStat(int total, WordStat stat) {
    return PieWordStat(stat.repetitions, stat.word,
        percentage: stat.repetitions / total, totalWords: total);
  }

  @override
  String toString() =>
      'PieWordStat(word: $word, reps: $repetitions , percentage: $percentage , totalWords :$totalWords)';
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

  List<PieWordStat> getMostRepeatedPieStats(int amount) {
    final stats = getMostRepeated(amount);

    return stats.map((e) => PieWordStat.fromWordStat(_totalWords, e)).toList();
  }

  List<WordStat> getLeastRepeated(int amount) {
    final registry = {..._wordCounterRegistry};
    var wordStats = <WordStat>[];
    for (final entry in registry.entries) {
      wordStats.add(WordStat(entry.value, entry.key));
    }
    wordStats = wordStats.bubbleSort(ascendent: true);
    if (amount > registry.length) {
      return wordStats;
    }
    final sublist = wordStats.sublist(0, amount);
    return sublist;
  }

  List<PieWordStat> getLeastRepeatedPieStats(int amount) {
    final stats = getLeastRepeated(amount);

    return stats.map((e) => PieWordStat.fromWordStat(totalWords, e)).toList();
  }

  WordStat getStatsForWord(String word) {
    try {
      final count = registry[word]!;
      return WordStat(count, word);
    } catch (e) {
      return WordStat(0, word);
    }
  }

  List<WordStat> getStatsForList(List<String> words,
      {bool sort = true, bool caseSensitive = false}) {
    List<WordStat> wordList = [];
    words = words.toSet().toList();
    for (final word in words) {
      final wordStat =
          getStatsForWord(caseSensitive ? word : word.toLowerCase());
      wordList.add(wordStat);
    }
    if (sort) {
      return wordList.bubbleSort();
    }
    return wordList;
  }

  PieWordStat getPieStatsForWord(String word) {
    final wordStat = getStatsForWord(word);
    return PieWordStat.fromWordStat(totalWords, wordStat);
  }

  List<PieWordStat> getPieStatsForList(List<String> words) {
    final wordStatList = getStatsForList(words);
    return wordStatList
        .map((e) => PieWordStat.fromWordStat(totalWords, e))
        .toList();
  }

  List<WordStat> filter(bool Function(WordStat element) compute) {
    final registry = {..._wordCounterRegistry};
    var wordStats = <WordStat>[];
    for (final entry in registry.entries) {
      final wordStat = WordStat(entry.value, entry.key);
      final mustAdd = compute(wordStat);
      if (mustAdd) {
        wordStats.add(WordStat(entry.value, entry.key));
      }
    }
    return wordStats;
  }

  List<PieWordStat> transformToPieWordChart(List<WordStat> wordStats) =>
      wordStats.map((e) => PieWordStat.fromWordStat(totalWords, e)).toList();

  List<PieWordStat> filterPieChart(bool Function(WordStat element) compute) {
    final registry = {..._wordCounterRegistry};
    var wordStats = <WordStat>[];
    for (final entry in registry.entries) {
      final wordStat = WordStat(entry.value, entry.key);
      final mustAdd = compute(wordStat);
      if (mustAdd) {
        wordStats.add(WordStat(entry.value, entry.key));
      }
    }
    return wordStats
        .map((e) => PieWordStat.fromWordStat(totalWords, e))
        .toList();
  }
}
