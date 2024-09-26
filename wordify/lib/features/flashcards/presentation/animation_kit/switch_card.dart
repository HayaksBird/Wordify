import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';

///Allows to control the state of the SwitchCard's state through a variable
///reference
class SwitchCardController {
  _SwitchCardState? _state;


  ///Specify that once a new card is passed, shift the view by
  ///sliding to the left.
  void slideLeft() => _state?.slideLeft();


  ///Specify that once a new card is passed, shift the view by
  ///sliding to the right.
  void slideRight() => _state?.slideRight();
}



///Switch the view between the old flashcard and the new flashcard.
///
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


  ///Specify that once a new card is passed, shift the view by
  ///sliding to the left.
  void slideLeft() { _doSlideRight = false; }


  ///Specify that once a new card is passed, shift the view by
  ///sliding to the right.
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