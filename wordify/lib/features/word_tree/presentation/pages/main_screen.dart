import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/pages/word_template.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';


///Show the main screen with the dictionary of words
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  final _bloc = DictionaryBloc();


  ///
  @override
  void initState() {
    super.initState();
    _bloc.loadInitialData(); 
  }


  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }


  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordify'),
      ),
      ///The body listens to the stream, which will return the updated istance of the dictionary.
      ///After the new istance is received from the stream, the state of the list widget will
      ///be updated.
      body: StreamBuilder<Dictionary>(
        stream: _bloc.dictionaryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          } else {
            return _buildWordList(snapshot.data!);
          }
        },
      ),
      floatingActionButton: _buildAddWordButton()
    );
  }


  ///Add a new word
  Widget _buildAddWordButton() {
    return FloatingActionButton(
      onPressed: () {
        _openWordTemplate();  //Add a new element
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
        _openWordTemplate(word, index);
      },
      child: ListTile (
        title: Text(word.word),
        subtitle: Text(word.translation)
      )
    );
  }


  ///
  Future<void> _openWordTemplate([Word? word, int? index]) async {
    //Specify that the pushed route will return an instance of Word
    final Word? newWord = await Navigator.of(context).push<Word>(
      MaterialPageRoute(
        builder: (_) => WordTemplate(
          word: (word ?? const Word()) 
        )
      )
    );

    if (word == null) { _bloc.createWord(newWord); }
    else { _bloc.updateWord(newWord, index!); }
  }
}