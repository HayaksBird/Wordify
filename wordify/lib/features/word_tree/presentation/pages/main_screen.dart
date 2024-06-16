import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_list_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_list_widget.dart';


///
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Row(
        children: [
          Expanded( //Folders column
            flex: 25,
            child: FolderListWidget()
          ),
          Expanded( //Words column
            flex: 75,
            child: WordListWidget()
          )
        ]
      ),
      floatingActionButton: AddWordButton(
        onPressed: () => _openWordTemplate(context)
      ),
    );
  }


  ///
  void _openWordTemplate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateWordTemplate()
      ),
    );
  }
}