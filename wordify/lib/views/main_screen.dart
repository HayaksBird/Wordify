import 'package:flutter/material.dart';
import 'package:wordify/views/word_template.dart';
import 'package:wordify/models/data_layer.dart';


///Show the main screen with the dictionary of words
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  Dictionary dictionary = const Dictionary ();


  ///Dictionary with an 'add' button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordify'),
      ),
      body: _buildWordList(),
      floatingActionButton: _buildAddWordButton()
    );
  }


  ///Add a new word
  Widget _buildAddWordButton() {
    return FloatingActionButton(
      onPressed: () {
        _updateWord(context, -1);  //Add a new element
      },
      child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255))
    );
  }


  ///Build a list widget from the word list
  Widget _buildWordList() {
    return ListView.builder(
      itemCount: dictionary.words.length,
      /*
      itemBuilder accepts an anonymous function that basically specifies 
      how exactly the list element at an index i should be displayed
      */
      itemBuilder: (context, index) => _buildWordTile(dictionary.words[index], index)
    );
  }


  ///Each list element will be wrapped by a InkWell, so that when clicked
  ///its corresponding template will open
  Widget _buildWordTile(Word word, int index) {
    return InkWell (
      onTap: () { //If clicked, open the corresponding template
        _updateWord(context, index);
      },
      child: ListTile (
        title: Text(word.word),
        subtitle: Text(word.translation)
      )
    );
  }


  ///Will open a new screen, while this method will wait (async) until the new screen
  ///finishes and returns a new word. The new word is then added to the list.
  Future<void> _updateWord(BuildContext context, int index) async {
    //Specify that the pushed route will return an instance of Word
    final Word? newWord = await Navigator.of(context).push<Word>(
      MaterialPageRoute(
        builder: (_) => WordTemplate(
          word: (index != -1 ? dictionary.words[index] : const Word()) 
        )
      )
    );

    if (newWord == null) return;

    setState(() {
      if (index != -1) {
        dictionary = Dictionary(
          words: List<Word>.from(dictionary.words)
            ..[index] = newWord
        );
      } else {
        dictionary = Dictionary(
          words: List<Word>.from(dictionary.words)
            ..add(newWord)
        );
      }
    });
  }
}