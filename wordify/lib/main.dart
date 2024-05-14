import 'package:flutter/material.dart';
import 'package:wordify/models/data_layer.dart';
import 'package:wordify/state/dictionary_provider.dart';
import 'package:wordify/views/main_screen.dart';


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