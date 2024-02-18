import 'package:writing_tools/read_stats.dart';

extension BubbleSorting on List<WordStat> {
  List<WordStat> bubbleSort({bool ascendent = false}) {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      for (var j = i + 1; j < length; j++) {
        WordStat elementA = this[i];
        WordStat elementB = this[j];
        if (!ascendent) {
          if (elementB.repetitions > elementA.repetitions) {
            this[i] = elementB;
            this[j] = elementA;
          }
        } else {
          if (elementA.repetitions > elementB.repetitions) {
            this[i] = elementB;
            this[j] = elementA;
          }
        }
      }
    }
    return this;
  }
}
