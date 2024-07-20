import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/folder_view/folder_list_template_widget.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_list_widget.dart';


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
    _dictionaryBloc.state.loadFolders();
  }


  @override
  void dispose() {
    super.dispose();
    _dictionaryBloc.state.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FolderListTemplateWidget(
      child: GestureDetector(
        onSecondaryTap: () => _createFolder(),
        child: Stack(
          children: [
            StreamBuilder<List<Folder>>(
              stream: _dictionaryBloc.state.foldersInView,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return FolderListWidget(rootFolders: snapshot.data!);
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