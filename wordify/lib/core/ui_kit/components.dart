import 'package:flutter/material.dart';

///
class WordifyOverlayEntry extends StatelessWidget {
  final List<DoAction> inputs;
  final Offset position;
  final OverlayEntry overlayEntry;
  final VoidCallback? onOverlayClosed;


  const WordifyOverlayEntry({
    super.key,
    required this.inputs,
    required this.position,
    required this.overlayEntry,
    this.onOverlayClosed
  });


  ///When the overlay is shown, the screen is fully occupied by GestureDetector which is when 
  ///clicked, closes the overlay. However, if the widgets inside of GestureDetector have
  ///their own onTap methods, then their own onTap methods will be trigered if they are pressed.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        overlayEntry.remove();
        onOverlayClosed?.call();
      },
      onSecondaryTap: () {
        overlayEntry.remove();
        onOverlayClosed?.call();
      },
      onLongPress: () {
        overlayEntry.remove();
        onOverlayClosed?.call();
      },
      behavior: HitTestBehavior.translucent,
      ///Use stack, so that the Positioned widget does not occupy the whole space of
      ///GestureDetector (the whole screen)
      child: Stack(
        children: [
          Positioned(
            left: position.dx + 10, // Just to the right of the cursor
            top: position.dy, // Slightly below the cursor
            child: Material(
              elevation: 4.0,
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: inputs.map((input) {
                    return ListTile(
                      title: Text(input.title),
                      onTap: () {
                        overlayEntry.remove();
                        input.action();
                        onOverlayClosed?.call();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  static void showOverlay({
    required List<DoAction> inputs,
    required BuildContext context,
    required Offset tapPosition,
    VoidCallback? onOverlayClosed
  }) {
    late final OverlayEntry overlayEntry; // Use late to declare first

    overlayEntry = OverlayEntry(
      builder: (context) => WordifyOverlayEntry(
        inputs: inputs,
        position: tapPosition,
        overlayEntry: overlayEntry,
        onOverlayClosed: onOverlayClosed
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}


///A void callback action container, which contains the action itself and its
///description.
class DoAction {
  final String title;
  final Function action;


  const DoAction({
    required this.title,
    required this.action
  }); 
}