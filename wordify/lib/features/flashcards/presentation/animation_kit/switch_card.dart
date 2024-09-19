import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';

class SwitchCardController {
  _SwitchCardState? _state;


  void slideLeft() => _state?.slideLeft();


  void slideRight() => _state?.slideRight();
}



class SwitchCard extends StatefulWidget {
  final Widget child;
  final SwitchCardController controller;
  final WordContentStats identifier;


  const SwitchCard({
    super.key,
    required this.child,
    required this.identifier,
    required this.controller
  });


  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  bool _doSlideRight = true;


  void slideLeft() { _doSlideRight = false; }


  void slideRight() { _doSlideRight = true; }


  @override
  Widget build(BuildContext context) {
    widget.controller._state = this;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (Widget child, Animation<double> animation) {
        ///Slide to the right
        final animateOutSlideRight = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn, // Out animation curve
          reverseCurve: Curves.easeIn,
        ));

        final animateInSlideRight = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutQuad, // Out animation curve
          reverseCurve: Curves.easeInOutQuad,
        ));

        ///Slide to the left
        final animateOutSlideLeft = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn, // Out animation curve
          reverseCurve: Curves.easeIn,
        ));

        final animateInSlideLeft = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutQuad, // Out animation curve
          reverseCurve: Curves.easeInOutQuad,
        ));
        
        final isOldWidget = (child.key as ValueKey).value != widget.identifier;

        return SlideTransition(
          position: _doSlideRight ?
          (isOldWidget ? animateOutSlideRight : animateInSlideRight) :
          (isOldWidget ? animateOutSlideLeft : animateInSlideLeft),
          child: child,
        );
      },
      child: widget.child
    );
  }
}