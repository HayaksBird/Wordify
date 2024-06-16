import 'package:flutter/material.dart';

///
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


///
class FolderContentTemplate extends StatelessWidget {
  final Widget folderContent;


  const FolderContentTemplate({super.key, required this.folderContent});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 194, 152, 227),
      child: FractionallySizedBox(
        widthFactor: 0.95,
        alignment: Alignment.centerRight,
        child: Container(
          color: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100.0, // Set a minimum height
              maxHeight: 500.0, // Set a maximum height to constrain the size
            ),
            child: folderContent,
          ),
        ),
      ),
    );
  }
}