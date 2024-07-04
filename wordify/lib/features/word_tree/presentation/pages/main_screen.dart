import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/pages/word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_view_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_view_widget.dart';


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
            child: FolderViewWidget()
          ),
          Expanded( //Words column
            flex: 75,
            child: WordViewWidget()
          )
        ]
      ),
      floatingActionButton: WordifyFloatingActionButton(
        onPressed: () => _openWordTemplate(context),
        tooltip: 'Add a word',
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