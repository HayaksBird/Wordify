///A word
abstract class WordContentStats {
  String get word;
  String get translation;
  String? get sentence;
  int get oldestAttempt;
  int get middleAttempt;
  int get newestAttempt;
}