import 'package:wordify/core/domain/entities/folder.dart';

///A word interface that will be used to reference an actual word object
///received from the data layer.
abstract class WordContent {
  String get word;
  String get translation;
  String? get sentence;
}


///A word
abstract class WordContentStats {
  String get word;
  String get translation;
  String? get sentence;
  int get oldestAttempt;
  int get middleAttempt;
  int get newestAttempt;
  FolderContent get folder; 
}