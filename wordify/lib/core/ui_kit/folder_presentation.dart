import 'package:flutter/material.dart';

///
class FolderList extends StatelessWidget {
  final Widget child;



  const FolderList({
    super.key,
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color.fromARGB(255, 37, 6, 6), width: 1.0),
        ),
      ),
      child: Material(
        color: const Color.fromARGB(255, 194, 152, 227),
        child: child
      )
    );
  }
}



///
class ChooseFolder extends StatelessWidget {
  final Widget folders;
  final VoidCallback goBack;
  final String path;


  const ChooseFolder({
    super.key,
    required this.folders,
    required this.goBack,
    required path 
  }) : path = 'Saving to: $path';


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: const Border(
              top: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2.0,
              ),
              // No bottom border
            ),
            borderRadius: BorderRadius.circular(0), // Optional: adds rounded corners
          ),
          width: double.infinity,
          child: IconButton(
            onPressed: goBack,
            icon: const Icon(
              Icons.arrow_circle_left,
              color: Color.fromARGB(255, 0, 0, 0), // Changed color to make it visible against white background
              size: 20.0,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            border: const Border(
              top: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2.0,
              ),
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          child: folders,
        ),

        Text(path)
      ]
    );
  }
}



///
class FolderTile extends StatelessWidget {
  final bool isExpanded;
  final ListTile listTile;
  final void Function() toggleFolder;
  final void Function() expandFolder;
  final void Function(TapDownDetails) folderOperations;


  const FolderTile({
    super.key,
    required this.isExpanded,
    required this.listTile,
    required this.toggleFolder,
    required this.expandFolder,
    required this.folderOperations
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: toggleFolder,
          icon: isExpanded ?
          const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Colors.black,
            size: 20.0,
          ) :
          const Icon(
            Icons.keyboard_arrow_right_sharp,
            color: Colors.black,
            size: 20.0,
          ),
        ),

        Expanded(
          child: GestureDetector(
            onDoubleTap: expandFolder,
            onSecondaryTapDown: folderOperations,
            child: listTile
          )
        )
      ],
    );
  }
}