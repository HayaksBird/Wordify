///This file contains the numeric values needed for the construction of the
///flashcards algorithm.
///
///maxRating indicats the maximum rating a user can give to his performance with
///giving the correct translation of a word. 
///Example: maxRating = 3 -> ratings: 1, 2, 3
///
///attemptsStored shows how much record history of attempts will be stored in the database.
///Currently for each word there will be a history of its 3 previous attempts.
///Example: Oldest score -> 2, Middle score -> 1, Newest score -> 3
///
///weightFactor is used to weigh the score before averaging it. This is done to prioritize
///the more fresh attempts over the older attempts (How you have scored in a more recent time
///matters more).
///The weight for each attempt is equal to weightFactor multiplied by the attempt's position from
///the end.
///Example: weightFactor = 0.5; attemptsStored = 3; maxRating = 3;
///Oldest attempt - 2, middle attempt - 3, newest attempt - 1;
///weight of the oldest attempt = 2 * (0.5 * 1),
///weight of the middle attempt = 3 * (0.5 * 2),
///weight of the middle attempt = 1 * (0.5 * 3);
///
///performanceInterval will be used to create three categories of arrays, where
///the score interval for each one of them is the same.
///Example: If maxRating is 3 then performanceInterval ≈ 0.67
///So the first array will contain the words where with the weighted average of 1 - 1.67
///The second array -> 1.67 - 2.34
///The thrid array with highest scored -> 2.34 - 3
const int maxRating = 3;
const int attemptsStored = 3;
final double weightFactor = _countWeightFactor;
final double performanceInterval = _countPerformanceInterval;


///This algorithm chooses such weightFactor so that the weighted average score
///will lie between 1 and maxRating.
double get _countWeightFactor {
  int sum = ((attemptsStored * (attemptsStored + 1)) / 2).truncate();

  return double.parse((attemptsStored / sum).toStringAsFixed(2)); //2 digits after the dot
}


///Get the interval to split the maxRating into three equal parts. (Will be
///used for the flashcards algorithm).
double get _countPerformanceInterval {
  return double.parse(((maxRating - 1) / 3).toStringAsFixed(2));
}