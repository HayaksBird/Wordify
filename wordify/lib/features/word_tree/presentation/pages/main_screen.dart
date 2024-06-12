import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_list_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_list_widget.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded( //Folders column
            flex: 35,
            child: _folderColumn()
          ),
          Expanded( //Words column
            flex: 65,
            child: _wordColumn()
          )
        ]
      ),
    );
  }


  ///
  Widget _folderColumn() {
    return const Material(
      color: Color.fromARGB(255, 194, 152, 227),
      child: FolderListWidget()
    );
  }


  ///
  Widget _wordColumn() {
    return const WordListWidget();
  }
}