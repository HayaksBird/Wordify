import 'package:flutter/material.dart';
import 'package:wordify/state/dictionary_provider.dart';
import 'package:wordify/views/word_template.dart';
import 'package:wordify/models/data_layer.dart';
import 'package:wordify/services/word_service.dart';


///Show the main screen with the dictionary of words
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  bool _isInit = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordify'),
      ),
      body: ValueListenableBuilder<Dictionary>( //Rebuild when Dictionary is changed
        valueListenable: DictionaryProvider.of(context),  //Get ValueNotifier<Dictionary>
        builder: (context, dictionary, child) { //Triggered when the ValueNotifier's value changes.
          if (!_isInit) { _loadInitialData(DictionaryProvider.of(context)); }
          return _buildWordList(dictionary);
        },
      ),
      floatingActionButton: _buildAddWordButton()
    );
  }


  ///
  Future<void> _loadInitialData(ValueNotifier<Dictionary> notifier) async {
    _isInit = true;

    Dictionary initialDictionary = await WordService.getAll();
    notifier.value = initialDictionary;
  }


  ///Add a new word
  Widget _buildAddWordButton() {
    return FloatingActionButton(
      onPressed: () {
        _createWord(context);  //Add a new element
      },
      child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255))
    );
  }


  ///Build a list widget from the word list
  ///itemBuilder accepts an anonymous function that basically specifies 
  ///how exactly the list element at an index i should be displayed
  Widget _buildWordList(Dictionary dictionary) {
    return ListView.builder(
      itemCount: dictionary.words.length,
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


  ///
  Future<Word?> _openWordTemplate([Word? word]) async {
    //Specify that the pushed route will return an instance of Word
    final Word? newWord = await Navigator.of(context).push<Word>(
      MaterialPageRoute(
        builder: (_) => WordTemplate(
          word: (word ?? const Word()) 
        )
      )
    );

    return newWord;
  }


  ///Add a new word to the dictionary.
  Future<void> _createWord(BuildContext context) async {
    ValueNotifier<Dictionary> dictionaryNotifier = DictionaryProvider.of(context);
    Dictionary currentDictionary = dictionaryNotifier.value;

    //Specify that the pushed route will return an instance of Word
    final Word? newWord = await _openWordTemplate();

    if (newWord == null) return;

    final Word indexedWord = await WordService.insert(newWord);

    //Change the value of the notifier, so that the widget gets redrawn.
    dictionaryNotifier.value = Dictionary(
        words: List<Word>.from(currentDictionary.words)
          ..add(indexedWord)
      );
  }


  ///Update the word.
  Future<void> _updateWord(BuildContext context, int index) async {
    ValueNotifier<Dictionary> dictionaryNotifier = DictionaryProvider.of(context);
    Dictionary currentDictionary = dictionaryNotifier.value;

    final Word? newWord = await _openWordTemplate(currentDictionary.words[index]);

    if (newWord == null) return;

    WordService.update(newWord);

    dictionaryNotifier.value =  Dictionary(
      words: List<Word>.from(currentDictionary.words)
        ..[index] = newWord
    );
  }
}