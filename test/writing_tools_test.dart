import 'package:test/test.dart';
import 'package:writing_tools/read_stats.dart';
import 'package:writing_tools/text_analyzer.dart';

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
      textAnalyzer.minCharactersNeededToRegister = 20;
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      print(totalWords);

      final wordStat = readStats.getStatsForWord('esquirlada');
      print(wordStat);

      final repeated = readStats.getMostRepeated(20);
      print(repeated);
      print(readStats.getLeastRepeated(20));

      final pieStat = readStats.getPieStatsForWord('kaladin');
      print(repeated.map((e) => PieWordStat.fromWordStat(totalWords, e)).toList());

      expect(pieStat.percentage,
          equals(pieStat.repetitions / readStats.totalWords));
      print(pieStat);

      final pieStats = readStats.getPieStatsForList([
        'kaladin',
        'dalinar',
        'shallam',
        'adolin',
        'renarin',
        'parshendi',
        'tormenta',
        'luz',
        'tormentosa'
      ]);
      print(pieStats);
      final totalPerc = pieStats.fold<num>(
          0.0, (previousValue, element) => previousValue + element.percentage);
      print(totalPerc);
    });

    test('analyze LPDA', () async {
      final path = 'test/test_5.txt';
      final textAnalyzer = TextAnalyzer(path);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;

      print(totalWords);
      print(readStats.registry.entries.take(20).toList());
    });
  });
}
