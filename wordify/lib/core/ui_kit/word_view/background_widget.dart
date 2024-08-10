import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget wordView;


  const Background({
    super.key,
    required this.wordView
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background.png'),
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),

        wordView
      ]
    );
  }
}