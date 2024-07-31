import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_view_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_view_widget.dart';


///
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});


  ///The WordViewWidget and the FolderViewWidget visually are placed next to each other,
  ///but in actuality the FolderViewWidget will be place above to allow the overflow.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(  //WordViewWidget placed below
            children: [
              Expanded(
                flex: 25,
                child: _voidContainer,
              ),
              const Expanded(
                flex: 75,
                child: WordViewWidget(),
              )
            ],
          ),

          Row(  //FolderViewWidget placed above
            children: [
              const Expanded(
                flex: 25,
                child: FolderViewWidget(),
              ),
              Expanded(
                flex: 75,
                child: _voidContainer,
              ),
            ],
          )
        ],
      ),
      floatingActionButton: WordifyFloatingActionButton(
        onPressed: () => _openWordTemplate(context),
        tooltip: 'Add a word',
      ),
    );
  }


  Widget get _voidContainer {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        color: Colors.transparent,
      ),
    );
  }


  ///
  void _openWordTemplate(BuildContext context) {
    final dictionaryBloc = DictionaryBloc();
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateWordTemplate(storageFolder: dictionaryBloc.folderView.bufferFolder)
      ),
    );
  }
}