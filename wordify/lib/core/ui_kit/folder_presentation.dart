import 'package:flutter/material.dart';

///Header for the active (opened) folder that shows the
///name of the folder itself. In addition, contains the button to close
///the directory.
class FolderHeader extends StatelessWidget {
  final String name;
  final VoidCallback closePressed;


  const FolderHeader({
    super.key, 
    required this.name,
    required this.closePressed
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 194, 152, 227),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18
            )
          ),
          const Spacer(),
          IconButton(
            onPressed: closePressed,
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 20.0,
            ), 
          ),
        ],
      ),
    );
  }
}


///Takes the list of words and places it on a container in a such way that
///the sides of the container are being exposed. This allows to scroll through the
///list of opened folders.
class FolderContentTemplate extends StatelessWidget {
  final Widget folderContent;


  const FolderContentTemplate({super.key, required this.folderContent});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 194, 152, 227),
      child: FractionallySizedBox(
        widthFactor: 0.90,
        alignment: Alignment.center,
        child: Material(
          color: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500.0, // Set a maximum height to constrain the size
            ),
            child: folderContent,
          ),
        ),
      ),
    );
  }
}


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