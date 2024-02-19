
import 'package:writing_tools/analysis_options.dart';
import 'package:writing_tools/analyze_file.dart';
import 'package:writing_tools/read_stats.dart';


class TextAnalyzer {
  // atributos
  final String path;
  AnalysisOptions options;
  // constructor
  TextAnalyzer(this.path, this.options);

  Future<ReadStats> analyze() async {
    assert(options.minCharactersNeededToRegister > 0, '''
      minCharactersNeededToRegister must be greater than 0
    ''');
    final analysisFile = AnalysisFile(path, options);
    final readStats = await analysisFile.analyze();
    return readStats;
  }
}
