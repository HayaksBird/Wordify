import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
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
        scaffoldBackgroundColor: AppColors.backgroundMain
      ),
      home: const MainScreen()
    );
  }
}