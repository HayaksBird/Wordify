import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/folder_view/folder_list_template_widget.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_tree_widget.dart';


///Present the list of type FolderContentWidget,
///showing all words in an active folder list.
class FolderViewWidget extends StatefulWidget {
  const FolderViewWidget({super.key});

  @override
  State<FolderViewWidget> createState() => _FolderViewWidgetState();
}


class _FolderViewWidgetState extends State<FolderViewWidget> {
  final _dictionaryBloc = DictionaryBloc();


  @override
  void initState() {
    super.initState();
    _dictionaryBloc.folderView.loadFolders();
  }


  @override
  void dispose() {
    super.dispose();
    _dictionaryBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FolderListTemplateWidget(
      child: GestureDetector(
        onSecondaryTap: () => _createFolder(),
        onDoubleTap: () { _dictionaryBloc.wordView.accessBufferFolder(); },
        child: Stack(
          children: [
            StreamBuilder<List<Folder>>(
              stream: _dictionaryBloc.folderView.foldersInView,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return FolderTreetWidget(rootFolders: (snapshot.data!));
                }
              },
            )
          ],
        )
      )
    );
  }


  ///
  void _createFolder() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateFolderTemplate()
      ),
    );
  }
}