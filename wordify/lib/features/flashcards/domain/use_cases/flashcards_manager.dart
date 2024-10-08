import 'dart:math';

import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/use_cases/assets.dart';

///This class sets the algorithm for the flashcards.
///It takes a list of words to be used with flashcards and organizes them
///into category lists -> worst, average, best.
///Once the user requests the next word it will be given to them from one of
///these 3 categories depending on the algorithm.
class FlashcardsManager {
  int _currentCategory = 0;
  int _wordsTakenFromGivenCategory = 0;
  final Random _random = Random();

  final List<WordContentStats> _worstLearned = [], _averageLearned = [], _bestLearned = [];
  late final List<_MaxWordsForCategory> _allPerformanceLists;


  ///Set the category lists with the maximum count of words for each category list
  ///which tells how many words can be extracted from the category list before
  ///moving on to the next one.
  FlashcardsManager() {
    _allPerformanceLists = [
      _MaxWordsForCategory(_worstLearned, 4),
      _MaxWordsForCategory(_averageLearned, 2),
      _MaxWordsForCategory(_bestLearned, 1)
    ];
  }


  ///Count the weighted average score for each word and depending on that value, place the word
  ///in either of the three lists (worst, average, best).
  void setFlashcards(List<WordContentStats> words) {
    _reset();

    for (WordContentStats word in words) {
      double weightedAverageScore = (weightFactor * (word.oldestAttempt + (2 * word.middleAttempt) + (3 * word.newestAttempt))) / attemptsStored;

      if (weightedAverageScore < (1 + performanceInterval)) {
        _worstLearned.add(word);
      } else if (weightedAverageScore < (1 + performanceInterval * 2)) {
        _averageLearned.add(word);
      } else {  ///weightedAverageScore <= (1 + performanceInterval * 3)
        _bestLearned.add(word);
      }
    }
  }


  ///Get the next word to give to the user.
  ///We will rotate over the three categories of lists.
  ///If the user is currently in the worst category (the words they have learned the worst)
  ///then we take 4 words from this category before we move onwards.
  ///The next category would be the words they have learned at an average level.
  ///Take 2 words and move onwards ot the best category. Since user knows these words the best,
  ///we only take one word.
  ///
  ///We will rotate through these categories until all three lists don't empty out.
  ///Once that happens we return null. Meaning, the user has went through all the words in the
  ///list.
  WordContentStats? get getNextWord {
    WordContentStats? word;

    for (int i = 0; i < _allPerformanceLists.length + 1; i++) {
      word = _getWordFromList(_allPerformanceLists[_currentCategory].categoryList, _allPerformanceLists[_currentCategory].wordsFromCurrentCategoryLimit);

      if (word != null) { break; }
      //Move to next category
      else { _currentCategory = (_currentCategory + 1) % _allPerformanceLists.length; }
    }

    return word;
  }


  ///This method decides whether to extract a word from the current category list or to move
  ///forward.
  ///If the _wordsTakenFromGivenCategory counter is still below the limit for that category
  ///then extract the word from the category list.
  ///Else reset the counter to 0 and return null signalling to change the category list. 
  WordContentStats? _getWordFromList(
    List<WordContentStats> categoryList,
    int wordsFromCurrentCategoryLimit
  ) {
    int pos;
    WordContentStats? word;

    if (_wordsTakenFromGivenCategory < wordsFromCurrentCategoryLimit && categoryList.isNotEmpty) {
      //Get a random word from the list
      pos = categoryList.length != 1 ? _random.nextInt(categoryList.length) : 0;
      word = categoryList[pos];
      categoryList.removeAt(pos);

      _wordsTakenFromGivenCategory++;
    } else {
      //Reset the counter
      _wordsTakenFromGivenCategory = 0;
    }

    return word;
  }

  
  ///
  void _reset() {
    _currentCategory = 0;
    _wordsTakenFromGivenCategory = 0;
    _worstLearned.clear();
    _averageLearned.clear();
    _bestLearned.clear();
  }
}



///What is the maximum number of words that can be taken from a category list at a time.
///Example: If the current category is the worst learned words, then you can only take 4 words
///after which you have to switch the categories.
class _MaxWordsForCategory {
  final List<WordContentStats> categoryList;
  final int wordsFromCurrentCategoryLimit;


  const _MaxWordsForCategory(this.categoryList, this.wordsFromCurrentCategoryLimit);
}