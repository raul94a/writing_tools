import 'dart:io';

import 'package:path/path.dart';
import 'package:writing_tools/analysis_options.dart';
import 'package:writing_tools/analyze_strategy.dart';
import 'package:writing_tools/extensions/string_extensions.dart';
import 'package:writing_tools/read_stats.dart';


enum FileType {
  docx,
  pdf,
  other,
  txt;

  const FileType();

  static FileType fromExtension(String path) {
    final ext = extension(path);
    if (ext == '.docx') {
      return FileType.docx;
    }
    if (ext == '.pdf') return FileType.pdf;
    if (ext == '.txt' || ext.isEmpty) return FileType.txt;
    return FileType.other;
  }
}

class AnalysisFile {
  final String path;
  final AnalysisOptions options;
  late ITextAnalyzeStrategy _analysisStrategy;

  AnalysisFile(this.path, this.options) {
    final type = FileType.fromExtension(path);
    switch (type) {
      case FileType.docx:
        _analysisStrategy = DocxAnalysis();
      case FileType.pdf:
        _analysisStrategy = PdfAnalysis();
      case FileType.other:
        throw Exception('Not allowed file');
      case FileType.txt:
        _analysisStrategy = TxtAnalysis();
    }
  }
  File get file => File(path);
  
  void setAnalysisStrategy(ITextAnalyzeStrategy strategy) =>
      _analysisStrategy = strategy;

  Future<ReadStats> analyze() async {
    return await _analysisStrategy.analyze(this);
  }

  bool shouldExcludeWordFromCounting(String word) {
    if (word.isEmpty) {
      return true;
    }
    if (word.isMonoSylable && options.excludeMonosilabes) {
      return true;
    }
    if (word.length < options.minCharactersNeededToRegister) {
      return true;
    }
    return false;
  }
}
