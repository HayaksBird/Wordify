import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

///
class WordListWidget extends StatelessWidget {
  final List<Word> words;


  const WordListWidget({
    super.key,
    required this.words
  });


  @override
  Widget build(BuildContext context) {
    return _buildList();
  }


  ///
  Widget _buildList() {
    return ListView.builder(
      itemCount: words.length * 2,
      itemBuilder: (context, index) => index.isEven ? 
      _buildFolderTile(context, words[index ~/ 2]) : 
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Divider(
          color: AppColors.text,
          height: 0,
          thickness: 0.1,
        ),
      ),
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, Word word) {
    return ListTile(
      title: Text(
        word.word,
        style: const TextStyle(
          color: AppColors.text,
        ),
      ),
      subtitle: Text(
        word.translation,
        style: const TextStyle(
          color: AppColors.text,
        ),
      ),
    );
  }
}