import 'package:flutter/material.dart';

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