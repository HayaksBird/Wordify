import 'package:flutter/material.dart';
import 'dart:math';

///Allows to control the state of the FlipCard's state through a variable
///reference
class FlipCardController {
  _FlipCardState? _state;


  Future<void> flipCard() async => _state?.flipCard();
}



///Add a flipping effect to shift the view from the back side widget to the 
///front side widget and vice versa.
class FlipCard extends StatefulWidget {
  final FlipCardController controller;
  final Widget front;
  final Widget back;


  const FlipCard({
    super.key,
    required this.controller,
    required this.front,
    required this.back
  });


  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  bool _isBack = false;
  late AnimationController _controller;


  ///
  @override
  void initState() {
    super.initState();

    ///The controller will contain the values between 0 and 1.
    ///During the given duration 
    _controller = AnimationController(
      duration: const Duration(milliseconds: 390),
      vsync: this,
    );
  }


  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  ///Flip the card
  Future<void> flipCard() async {
    _isBack = !_isBack;

    if (_isBack) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    } 
  }


  ///
  @override
  Widget build(BuildContext context) {
    widget.controller._state = this;  //Make the controller point to the current state!

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * pi;
        ///Apply 2 matrix transformations: the rotation and the scaling
        ///In combination they will give the effect of flipping a card.
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle)
          ..scale(1 + sin(angle) / 3.5);

        ///If currently the card is on the front side (depending on the angle)
        ///then present the front card widget else the back card widget.
        return _isFrontSide(angle) ?
          Transform(
            transform: transform,
            alignment: Alignment.center,
            child: widget.front
          ) :
          Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Transform( //Undo the mirror effect
              transform: Matrix4.identity()..rotateY(pi),
              alignment: Alignment.center,
              child: widget.back
            )
          );
      }
    );
  }


  ///The front side is 0 -> 90
  ///The back side 90 -> 180
  bool _isFrontSide(double angle) {
    const angle90 = pi / 2;
    
    return angle <= angle90; 
  }
}