import 'package:flutter/material.dart';

///
class FolderHeader extends StatelessWidget {
  final DoAction action;


  const FolderHeader({
    super.key, 
    required this.action
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
            action.title,
            style: const TextStyle(
              fontSize: 18
            )
          ),
          const Spacer(),
          IconButton(
            onPressed: () { action.action(); },
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
        widthFactor: 0.90,
        alignment: Alignment.center,
        child: Material(
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


///
class FoolderList extends StatelessWidget {
  final Widget child;


  const FoolderList({
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


///
class WordifyOverlayEntry extends StatelessWidget {
  final List<DoAction> inputs;
  final Offset position;
  final OverlayEntry overlayEntry;


  const WordifyOverlayEntry({
    super.key,
    required this.inputs,
    required this.position,
    required this.overlayEntry,
  });


  ///When the overlay is shown, the screen is fully occupied by GestureDetector which is when 
  ///clicked, closes the overlay. However, if the widgets inside of GestureDetector have
  ///their own onTap methods, then their own onTap methods will be trigered if they are pressed.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        overlayEntry.remove();
      },
      onSecondaryTap: () {
        overlayEntry.remove();
      },
      onLongPress: () {
        overlayEntry.remove();
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

  static void showOverlay(List<DoAction> inputs, BuildContext context, Offset tapPosition) {
    late final OverlayEntry overlayEntry; // Use late to declare first

    overlayEntry = OverlayEntry(
      builder: (context) => WordifyOverlayEntry(
        inputs: inputs,
        position: tapPosition,
        overlayEntry: overlayEntry,
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