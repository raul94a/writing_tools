class AnalysisOptions {
  bool caseSensitive;
  bool excludeMonosilabes;
  int minCharactersNeededToRegister;
  AnalysisOptions({
    this.caseSensitive = false,
    this.excludeMonosilabes = false,
    this.minCharactersNeededToRegister = 1,
  });

  @override
  String toString() =>
      'AnalysisOptions(caseSensitive: $caseSensitive, excludeMonosilabes: $excludeMonosilabes, minCharactersNeededToRegister: $minCharactersNeededToRegister)';
}
