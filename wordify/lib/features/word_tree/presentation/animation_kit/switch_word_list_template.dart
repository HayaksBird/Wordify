import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

class SwitchWordListTemplate extends StatelessWidget {
  final Widget wordListTemplateWidget;
  final FolderWords identifier;
  final bool didGoBelow;


  const SwitchWordListTemplate({
    super.key,
    required this.wordListTemplateWidget,
    required this.identifier,
    required this.didGoBelow
  });


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {

        //Slide down (go up)
        final inAnimationSlideDown = Tween<Offset>(  //For new widget
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut, // Out animation curve
          reverseCurve: Curves.easeInOut,
        ));

        final outAnimationSlideDown = Tween<Offset>(  //For old widget
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn, // Out animation curve
          reverseCurve: Curves.easeIn,
        ));

        //Slide up (go down)
        final inAnimationSlideUp = Tween<Offset>(  //For new widget 
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut, // Out animation curve
          reverseCurve: Curves.easeInOut,
        ));

        final outAnimationSlideUp = Tween<Offset>( //For old widget
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn, // Out animation curve
          reverseCurve: Curves.easeIn,
        ));

        final isOldWidget = (child.key as ValueKey).value != identifier;

        return SlideTransition(
          position: !didGoBelow ?
          (isOldWidget ? outAnimationSlideDown : inAnimationSlideDown) :
          (isOldWidget ? outAnimationSlideUp : inAnimationSlideUp),
          child: child,
        );
      },
      child: wordListTemplateWidget,
    );
  }
}