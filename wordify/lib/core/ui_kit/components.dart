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