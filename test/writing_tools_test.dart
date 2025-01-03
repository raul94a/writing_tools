import 'package:test/test.dart';
import 'package:writing_tools/analysis_options.dart';
import 'package:writing_tools/extensions/word_stat_extensions.dart';
import 'package:writing_tools/read_stats.dart';
import 'package:writing_tools/text_analyzer.dart';

void main() {
  final options = AnalysisOptions(
      caseSensitive: false,
      excludeMonosilabes: false,
      minCharactersNeededToRegister: 1);
  group('Text Stats: ', () {
    tearDown(() => print('\n'));
    setUp(() => print('===== STARTING TEST ===='));
    test('test_4.txt analysis', () async {
      final path = 'test/test_4.txt';
      final textAnalyzer = TextAnalyzer(path, options);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;
      expect(totalWords, 42);
      expect(wordMap['texto'], 6);
      final mostRepeated = readStats.getMostRepeated(2);
      expect(mostRepeated.length, 2);
      expect(mostRepeated.first.word, 'texto');
      expect(mostRepeated.last.word, 'prueba');
      final pieChartData = readStats.getMostRepeatedPieStats(6);
      pieChartData.toStringLine();
    });

    test('docx test', () async {
      final path = './docs/lpda.docx';

      final textAnalyzer = TextAnalyzer(path, options);

      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;

      final mostRepeated = readStats.getMostRepeated(1);
      mostRepeated.toStringLine();
      final pieChartData = readStats.getMostRepeatedPieStats(100);

      pieChartData.toStringLine();
    });

     test('pdf test', () async {
      final path = './docs/suen.txt';

      final textAnalyzer = TextAnalyzer(path, options);

      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;

      final mostRepeated = readStats.getMostRepeated(1);
      mostRepeated.toStringLine();
      final pieChartData = readStats.getMostRepeatedPieStats(100);

      pieChartData.toStringLine();
    });
    test('test_4.txt analysis filter() method', () async {
      final path = 'test/test_4.txt';
      final textAnalyzer = TextAnalyzer(path, options);
      final readStats = await textAnalyzer.analyze();

      var wordStats =
          readStats.filter((element) => element.word.contains('no'));

      expect(wordStats.length, 1);

      var pieCharts = readStats.transformToPieWordChart(wordStats);
      pieCharts.toStringLine();
      expect(pieCharts.first.percentage, greaterThan(0.14));

      wordStats = readStats.filter((element) => element.word.contains('la'));
      expect(wordStats.length, 2);
    });

    test('use test.txt file with know words', () async {
      final path = 'test/test.txt';
      final textAnalyzer = TextAnalyzer(path, options);
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
      final textAnalyzer = TextAnalyzer(path, options);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      final wordMap = readStats.registry;
      print(totalWords);
      readStats.getMostRepeated(5).toStringLine();
      expect(wordMap['lorem'], 4);
      expect(wordMap['ipsum'], 4);
      expect(wordMap['it'], 3);

      expect(totalWords, 91);
    });
    test('use longer text file with known words', () async {
      final path = 'test/test_3.txt';
      final textAnalyzer = TextAnalyzer(path, options);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;

      print(totalWords);
      print(readStats.textLength);
      readStats.getMostRepeated(5).toStringLine();
      print(readStats.registry['aliquam']);
      expect(totalWords, 500);
    });

    test('analyze El Camino de los Reyes', () async {
      var path = 'test/test_4.txt';
      path = 'docs/el_camino_reyes_ESP.txt';
      final textAnalyzer = TextAnalyzer(path, options);

      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      print(totalWords);

      final wordStat = readStats.getStatsForWord('esquirlada');
      print(wordStat);

      final repeated = readStats.getMostRepeated(20);
      repeated.toStringLine();
      readStats.getLeastRepeated(20).toStringLine();

      final pieStat = readStats.getPieStatsForWord('kaladin');
      repeated
          .map((e) => PieWordStat.fromWordStat(totalWords, e))
          .toList()
          .toStringLine();

      expect(pieStat.percentage,
          equals(pieStat.repetitions / readStats.totalWords));
      print(pieStat);

      print('\n');

      final sprenWords =
          readStats.filter((element) => element.word.contains('spren'));
      sprenWords.bubbleSort().toStringLine();
      print('\n');
      readStats.transformToPieWordChart(sprenWords).toStringLine();

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
      pieStats.toStringLine();
      final totalPerc = pieStats.fold<num>(
          0.0, (previousValue, element) => previousValue + element.percentage);
      print(totalPerc);
    });

    test('analyze LPDA', () async {
      final path = 'test/test_5.txt';
      final textAnalyzer = TextAnalyzer(path, options);
      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;

      print(totalWords);
      print(readStats.registry.entries.take(20).toList());
    });

    test('analyze Hero of Ages', () async {
      var path = 'test/test_4.txt';
      path = 'docs/hero_ages_EN.txt';
      final textAnalyzer = TextAnalyzer(path, options);

      final readStats = await textAnalyzer.analyze();
      final totalWords = readStats.totalWords;
      print(totalWords);

      final wordStat = readStats.getStatsForWord('alomancy');
      print(wordStat);

      final repeated = readStats.getMostRepeated(20);
      repeated.toStringLine();
      print('\n');
      readStats.getLeastRepeated(20).toStringLine();

      final pieStat = readStats.getPieStatsForWord('vin');
      repeated
          .map((e) => PieWordStat.fromWordStat(totalWords, e))
          .toList()
          .toStringLine();

      expect(pieStat.percentage,
          equals(pieStat.repetitions / readStats.totalWords));
      print(pieStat);

      final pieStats = readStats.getPieStatsForList([
        'vin',
        'kelsier',
        'sazed',
        'elend',
        'ruin',
        'preservation',
        'harmony',
        'steel',
        'hemalurgy'
      ]);
      print('\n');
      pieStats.toStringLine();
      final totalPerc = pieStats.fold<num>(
          0.0, (previousValue, element) => previousValue + element.percentage);
      print(totalPerc);
    });
  });
}
