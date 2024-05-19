import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_provider.dart';
import 'package:wordify/features/word_tree/presentation/pages/main_screen.dart';


void main() {
  runApp(const Wordify());
}


class Wordify extends StatelessWidget {
  const Wordify({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp( //A Google style widget
      //Set args
      title: 'Wordify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //Set the DictionaryProvider widget in the tree and set its notifier
      home: DictionaryProvider( 
        notifier: ValueNotifier<Dictionary>(const Dictionary()),
        child: const MainScreen(),
      ),
    );
  }
}