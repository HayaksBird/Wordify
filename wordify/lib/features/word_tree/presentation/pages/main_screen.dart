import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/presentation/animation_kit/expand_folder_view.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/folder_view/expand_view_widget.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/providers/is_folder_view_expanded_provider.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_view_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_view_widget.dart';


///Shows the main screen of the app which manages the split between between the WordViewWidget
///and the FolderViewWidget.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dictionaryBloc = DictionaryBloc();


  ///The WordViewWidget and the FolderViewWidget visually are placed next to each other,
  ///but in actuality the FolderViewWidget will be place above to allow the overflow.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsFolderViewExpandedProvider(
        notifier: ValueNotifier<bool>(false),
        child: Builder(
          builder: (context) {
            final ValueNotifier<bool> valueNotifier = IsFolderViewExpandedProvider.of(context);

            return Stack(
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
            
                ValueListenableBuilder<bool>(
                  valueListenable: valueNotifier,
                  builder: (context, toExpand, child) { //FolderViewWidget placed above
                    return _folderViewWidget(valueNotifier, toExpand ? 75 : 25, toExpand ? 25 : 75);
                  }
                )
              ],
            );
          }
        ),
      ),
      floatingActionButton: WordifyFloatingActionButton(
        onPressed: () => _openWordTemplate(context),
        tooltip: 'Add a word',
      ),
    );
  }


  ///Create a transpatent container that is clickanle through.
  Widget get _voidContainer {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        color: Colors.transparent
      ),
    );
  }


  ///Create semi transparent container for the WordViewWidget whent the folder
  ///view is expanded to partially block its view.
  Widget get _blockViewContainer {
    return IgnorePointer(
      ignoring: false,
      child: Container(
        color: Colors.black.withOpacity(0.5)
      ),
    ); 
  }


  ///Add new word.
  void _openWordTemplate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateWordTemplate(storageFolder: dictionaryBloc.folderView.bufferFolder)
      ),
    );
  }


  ///Either expand or shrink the view.
  void _toggleExpandView(ValueNotifier<bool> valueNotifier) {
    if (valueNotifier.value) { valueNotifier.value = false; }
    else { valueNotifier.value = true; }
  }


  ///Create the Folder view.
  Widget _folderViewWidget(ValueNotifier<bool> valueNotifier, int flex1, int flex2) {
    double width = MediaQuery.of(context).size.width;
    double width1 = (flex1 * width) / (flex1 + flex2);

    return Row(  
      children: [
        ExpandFolderView(
          width: width1,
          folderViewWidget: FolderViewWidget(folderViewExpandNotifier: valueNotifier)
        ),
        
        Expanded(
          flex: flex2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (valueNotifier.value)
                //Block the WordViewWidget view when the folder view is expanded 
                _blockViewContainer
              else 
                _voidContainer,

              Positioned( //ExpandViewWidget tile
                top: 0,
                left: -(ExpandViewWidget.diameter / 2),
                child: ExpandViewWidget(
                  isExpanded: valueNotifier.value,
                  expand: () { _toggleExpandView(valueNotifier); },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}