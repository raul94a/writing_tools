import 'dart:convert';
import 'package:writing_tools/analyze_file.dart';
import 'package:writing_tools/constants/constants.dart';
import 'package:writing_tools/doc_to_text.dart';
import 'package:writing_tools/extensions/string_extensions.dart';
import 'package:writing_tools/read_stats.dart';
import 'package:pdf_text_extraction/pdf_text_extraction.dart';


abstract interface class ITextAnalyzeStrategy {
  Future<ReadStats> analyze(AnalysisFile file);
}

class DocxAnalysis implements ITextAnalyzeStrategy {
  @override
  Future<ReadStats> analyze(AnalysisFile file) async {
    var readStats = ReadStats();

    int totalWords = 0;

    final length = file.file.lengthSync();
    readStats.setTextLength(length);

    final bytes = await file.file.readAsBytes();

    var string = docxToText(bytes);
    string = string.clean();
    final split = string.split(SPACE);
    for (var word in split) {
      if (file.shouldExcludeWordFromCounting(word)) {
        continue;
      }
      if (!file.options.caseSensitive) {
        word = word.toLowerCase();
      }
      totalWords += 1;
      readStats.registerWord(word);
    }

    readStats.setTotalWords(totalWords);
    return readStats;
  }
}

class PdfAnalysis implements ITextAnalyzeStrategy {
  @override
  Future<ReadStats> analyze(AnalysisFile file) async {
    var pdfLib = PDFToTextWrapping();
    var string = pdfLib.extractText(file.path,
        startPage: 1, endPage: pdfLib.getPagesCount(file.path));
  
    final readStats = ReadStats();

    int totalWords = 0;

    final length = string.length;
    readStats.setTextLength(length);

    //process
    string = string.clean();
    final split = string.split(SPACE);
    for (var word in split) {
      if (file.shouldExcludeWordFromCounting(word)) {
        continue;
      }
      if (!file.options.caseSensitive) {
        word = word.toLowerCase();
      }
      totalWords += 1;
      readStats.registerWord(word);
    }

    readStats.setTotalWords(totalWords);
    return readStats;
  }
}

class TxtAnalysis implements ITextAnalyzeStrategy {
  @override
  Future<ReadStats> analyze(AnalysisFile file) async {
    final readStats = ReadStats();

    int totalWords = 0;

    final length = file.file.lengthSync();
    readStats.setTextLength(length);

    final stream = file.file.openRead();
    await for (var data in stream) {
      final encoding = Utf8Decoder(allowMalformed: true);
      final decodedBytes = encoding.convert(data);
      String string = decodedBytes;
      //process
      string = string.clean();
      final split = string.split(SPACE);
      for (var word in split) {
        if (file.shouldExcludeWordFromCounting(word)) {
          continue;
        }
        if (!file.options.caseSensitive) {
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
